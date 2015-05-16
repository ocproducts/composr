<?php
/**
 * Photobucket API 
 * Fluent interface for PHP5
 * fopen url request method
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
 * FOPEN_URL request strategy
 * requires fopen url wrappers
 * 
 * @package PBAPI
 * @subpackage Request
 */
class PBAPI_Request_fopenurl extends PBAPI_Request {
    
    /**
     * Do actual request
     *
     * @param string $method HTTP method (get/put/post/delete)
     * @param string $url full url to request
     * @param array $params 
     * @return string response from request
     */
    protected function raw_request($method, $url, $params = array()) {
        
        //import overrides
        $fopen_params = $this->request_params;
        
        //setup context
        $fopen_params['http']['method'] = $method;
        
        //overridable
        if (empty($fopen_params['http']['user_agent'])) $fopen_params['http']['user_agent'] = __CLASS__;
            
        if ($method == 'POST') {
            //no auto redirects for post
            $fopen_params['http']['max_redirects'] = 0;

            if (self::detectFileUploadParams($params)) { //todo which params?
                $boundary = uniqid('xx');
                $fopen_params['http']['header']  = 'Content-Type: multipart/form-data; boundary='.$boundary;
                $fopen_params['http']['content'] = self::multipartEncodeParams($this->oauth_request->getParameters(), $boundary);
            } else {
                $fopen_params['http']['header']  = 'Content-Type: application/x-www-form-urlencoded';
                $fopen_params['http']['content'] = $this->oauth_request->toPostdata();
            }
        } else {
            //context for everyone else
            $fopen_params['http']['max_redirects'] = self::MAX_REDIRECTS;
        }
        
        $ctx = stream_context_create($fopen_params);

        $data = $this->fopenurl_request($ctx, $url);

        return $data;

    }

    /**
     * fopen url raw request with redirect handling
     * 
     * @param resource $ctx stream context resource
     * @param string $url url to request
     * @return string raw response
     */
    protected function fopenurl_request($ctx, $url) {
        $out = @file_get_contents($url, false, $ctx);

        //detect redirect from headers
        $httpcode_reg = '#HTTP/1\.\d (\d+)#';
        $grep = preg_grep($httpcode_reg, $http_response_header);
        preg_match($httpcode_reg, current($grep), $matches);
        $http_code = $matches[1];

        if (in_array($http_code, array(301, 302, 303, 307))) {
            //redirect detected, find URL to redirect to
            $redir_parts = false;
            $location_reg = '/Location:(.*)(\n|$)/';
            $grep = preg_grep($location_reg, $http_response_header);
            $redirline = current($grep);
            if ($redirline) {
                preg_match($location_reg, $redirline, $matches);
                $redir_parts = @parse_url(trim($matches[1]));
            }
            if ($redir_parts && $redir_parts['path']) {
                $last_parts = parse_url($url);

                //inherit scheme/host if only path given
                if (empty($redir_parts['scheme'])) $redir_parts['scheme'] = $last_parts['scheme'];
                if (empty($redir_parts['host'])) $redir_parts['host'] = $last_parts['host'];
                $redir_url = $redir_parts['scheme'] . '://' . $redir_parts['host'] . $redir_parts['path'] . (!empty($redir_parts['query'])?'?'.$redir_parts['query']:'');

                //do redirect re-request
                $this->redirect_depth++;
                if ($this->redirect_depth > self::MAX_REDIRECTS) {
                    throw new PBAPI_Exception('Too Many Redirects');
                }
                $out = $this->fopenurl_request($ctx, $redir_url);
            } else {
                throw new PBAPI_Exception('Invalid Redirect');
            }
        }

        if ($out == false) {
            throw new PBAPI_Exception('FOPENURL failed'); 
        }

        return $out;
    }
    
}
