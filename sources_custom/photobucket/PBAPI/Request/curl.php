<?php
/**
 * Photobucket API 
 * Fluent interface for PHP5
 * CURL request interface
 * 
 * @author Photobucket
 * @package PBAPI
 * @subpackage Request
 * 
 * @copyright Copyright Copyright (c) 2008, Photobucket, Inc.
 * @license http://www.opensource.org/licenses/mit-license.php The MIT License
 */

/**
 * Load Request parent
 */
require_once(dirname(__FILE__).'/../Request.php');

/**
 * CURL request strategy
 * Requires CURL to be available and loaded
 * 
 * @package PBAPI
 * @subpackage Request
 */
class PBAPI_Request_curl extends PBAPI_Request {

    /**
     * Do actual request
     *
     * @param string $method HTTP method (get/put/post/delete)
     * @param string $url full url to request
     * @param array $params 
     * @return string response from request
     */
    protected function raw_request($method, $url, $params = array()) {
        //pull in curl opts and override
        $curl_opts = $this->request_params;
        
        //overridable
        if (empty($curl_opts[CURLOPT_USERAGENT])) $curl_opts[CURLOPT_USERAGENT] = __CLASS__;
        
        //'permenant' curl options
        $curl_opts[CURLOPT_HEADER] = 1;
        $curl_opts[CURLOPT_RETURNTRANSFER] = 1;
        $curl_opts[CURLOPT_CUSTOMREQUEST] = $method;
        $curl_opts[CURLOPT_MAXREDIRS] = self::MAX_REDIRECTS;
        $curl_opts[CURLOPT_CONNECTTIMEOUT] = 3; 
        if ($method == 'POST') {
            $curl_opts[CURLOPT_POST] = 1;
            $curl_opts[CURLOPT_POSTFIELDS] = $params;

            //use custom code to re-post on Location: request from a POST here.
            //see http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html#sec10.3.2
            $curl_opts[CURLOPT_FOLLOWLOCATION] = 0;
        } else {
            //POST doesnt follow Location:/30x redirects, but others do because they
            //dont have a payload, so just let curl do it.
            $curl_opts[CURLOPT_FOLLOWLOCATION] = 1;
        }
        
        $ch = curl_init();
        @curl_setopt_array($ch, $curl_opts);

        $data = $this->curl_request($ch, $url);
        curl_close($ch);
        return $data;
    }

    /**
     * raw CURL request
     * 
     * @param resource $ch curl resource handle
     * @param string $url url to request
     * @return string raw response
     */
    protected function curl_request($ch, $url) {
        curl_setopt($ch, CURLOPT_URL, $url);
        $out = curl_exec($ch);
       
        if ($cerror = curl_errno($ch)) {
            throw new PBAPI_Exception('CURL: '.curl_error($ch), $cerror);
        }

        //get response info
        $header_size = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
        $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        $header = trim(substr($out, 0, $header_size));
        $data = trim(substr($out, $header_size));

        if (in_array($http_code, array(301, 302, 303, 307))) {
            //redirect detected, find URL to redirect to
            $redir_parts = false;
            if (preg_match('/Location:(.*?)(\n|$)/', $header, $match)) {
                $redir_parts = @parse_url(trim($match[1]));
            }
            if ($redir_parts && $redir_parts['path']) {
                $last_parts = parse_url($url);

                //auto inherit scheme/host if only path given
                if (empty($redir_parts['scheme'])) $redir_parts['scheme'] = $last_parts['scheme'];
                if (empty($redir_parts['host'])) $redir_parts['host'] = $last_parts['host'];
                $redir_url = $redir_parts['scheme'] . '://' . $redir_parts['host'] . $redir_parts['path'] . (!empty($redir_parts['query'])?'?'.$redir_parts['query']:'');

                //do redirect re-request
                $this->redirect_depth++;
                if ($this->redirect_depth > self::MAX_REDIRECTS) {
                    throw new PBAPI_Exception('Too Many Redirects');
                }
                $data = $this->curl_request($ch, $redir_url);
            } else {
                throw new PBAPI_Exception('Invalid Redirect');
            }
        }
        
        return $data;
    }
    
}
