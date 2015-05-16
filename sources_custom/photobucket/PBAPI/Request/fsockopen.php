<?php
/**
 * Photobucket API 
 * Fluent interface for PHP5
 * fsockopen request method
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
 * fsockopen request strategy
 * requires ability to use fsockopen
 * 
 * @package PBAPI
 * @subpackage Request
 */
class PBAPI_Request_fsockopen extends PBAPI_Request {
    
    /**
     * Do actual request
     *
     * @param string $method HTTP method
     * @param string $url full URL to get
     * @param array $params
     * @return string raw response
     */
    protected function raw_request($method, $url, $params = array()) {
        $parts = parse_url($url);
        
        //set starting points for length, post data, and response string
        $len = 0;
        $data = '';
        $post_payload = '';
        
        //open socket
        if ($fp = @fsockopen($parts['host'], 80)) {
            //generate request headers
            $path = (!empty($parts['path'])) ? $parts['path'] : '';
            $query = (!empty($parts['query'])) ? '?'.$parts['query'] : '';
            fputs($fp, "$method $path$query HTTP/1.1\n");
            fputs($fp, "Host: {$parts['host']}\n");
            fputs($fp, 'User-Agent: '.__CLASS__."\n");
            
            //generate request headers for post
            if ($method == 'POST') {
                if (self::detectFileUploadParams($params)) {
                    $boundary = uniqid('xx');
                    $post_payload = self::multipartEncodeParams($this->oauth_request->getParameters(), $boundary);
                    fputs($fp, "Content-Type: multipart/form-data; boundary=$boundary\n");
                } else {
                    $post_payload = $this->oauth_request->toPostdata();
                    fputs($fp, "Content-type: application/x-www-form-urlencoded\n");
                }

                $len = strlen($post_payload);
                fputs($fp, "Content-length: $len\n\n");
                fputs($fp, "$post_payload\n");
            }
            
            //put last newline to signal i'm done
            fputs($fp, "\n");
            
            $headers = true;
            $headertext = '';
            while (!feof($fp)) {
                $line = fgets($fp); //get lines
                if (trim($line) == '') $headers = false; //empty line will signal that we're done with headers
                else if ($headers) $headertext .= $line; //capture headers
                else if (!$headers) $data .= $line; //capture data
            }
            //close socket
            fclose($fp);

            //detect redirect from headers
            preg_match('#HTTP/1\.\d (\d+)#', $headertext, $matches);
            $http_code = $matches[1];

            if (in_array($http_code, array(301, 302, 303, 307))) {
                //redirect detected, find URL to redirect to
                $redir_parts = false;
                if (preg_match('/Location:(.*?)(\n|$)/', $headertext, $match)) {
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
                    $data = $this->raw_request($method, $redir_url, $params);
                } else {
                    throw new PBAPI_Exception('Invalid Redirect');
                }
            }

        } else {
            throw new PBAPI_Exception('FSOCKOPEN failed');
        }

        if ($data == false) {
            throw new PBAPI_Exception('FSOCKOPEN failed');
        }
        
        return $data;
    }
    
}
