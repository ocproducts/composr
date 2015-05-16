<?php
/**
 * OAuth Request
 * 
 * Adapted from Andy Smith's OAuth library for PHP
 * 
 * @link http://oauth.net/core/1.0
 * @link http://oauth.googlecode.com/svn/spec/ext/consumer_request/1.0/drafts/1/spec.html
 * @link http://oauth.googlecode.com/svn/code/php/
 * @link http://term.ie/oauth/example/
 * 
 * @package OAuth
 * 
 * @author jhart
 * @copyright Copyright (c) 2008, Photobucket, Inc.
 * @license http://www.opensource.org/licenses/mit-license.php The MIT License
 */

/**
 * Utilities
 */
require_once(dirname(__FILE__).'/Utils.php');
/**
 * Signing methods
 */
require_once(dirname(__FILE__).'/Signature.php');
/**
 * Consumer Model
 */
require_once(dirname(__FILE__).'/Consumer.php');
/**
 * Token Model
 */
require_once(dirname(__FILE__).'/Token.php');

/**
 * OAuth Request Representation
 * 
 * @package OAuth
 */
class OAuth_Request {
    
    /**
     * holds all parameters for request
     *
     * @access protected
     * @var array
     */
    public $parameters = array();

    /**
     * Holds HTTP method (normalized, strtoupper)
     *
     * @var string
     */
    public $http_method = '';

    /**
     * Holds url (normalized, per function)
     *
     * @var string
     */
    public $http_url = '';

    /**
     * generated base string for this request (debugging)
     *
     * @var string
     */
    public $base_string = '';
    /**
     * generated key string for this request (debugging)
     *
     * @var string
     */
    public $key_string = '';
    
    /**
     * Allowed version that we support with this library
     *
     * @var string
     */
    public static $version = '1.0';

    /**
     * Request Constructor
     *
     * @uses getNormalizedHttpUrl()
     * @param string $http_method http method
     * @param string $http_url url
     * @param array $parameters array of parameters
     */
    public function __construct($http_method, $http_url, $parameters = null) {
        @$parameters or $parameters = array();
        $this->parameters = $parameters;
        $this->http_method = strtoupper($http_method);
        $this->http_url = self::getNormalizedHttpUrl($http_url);
    }

    /**
     * build up a request from what was passed to the server
     * 
     * @param string $http_method [optional, default=_SERVER[HTTP_METHOD]] HTTP method (get|put|post|delete)
     * @param string $http_url [optional, default=http://_SERVER[HTTP_HOST]._SERVER[REQUEST_URI]] request url to sign
     * @param array $parameters [optional, default=_REQUEST] parameters to sign
     * @return self
     */ 
    public static function fromRequest($http_method=null, $http_url=null, $parameters=null) {
        @$http_url or $http_url = 'http://' . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'];
        @$http_method or $http_method = $_SERVER['REQUEST_METHOD'];

        if ($parameters) {
            $req = new self($http_method, $http_url, $parameters);
        } else {
            $parameters = array_diff_assoc($_REQUEST, $_COOKIE);
            
            $request_headers = apache_request_headers();
            if (array_key_exists('Authorization', $request_headers) && substr($request_headers['Authorization'], 0, 5) == 'OAuth') {
                $header = trim(substr($request_headers['Authorization'], 5)); //pull off 'OAuth' prefix
                $header_parameters = self::splitHeader($request_headers['Authorization']);
                $parameters = array_merge($header_parameters, $parameters);
            }
     
            $req = new self($http_method, $http_url, $parameters);
        }
        return $req;
    }
    
    /**
     * build up a request form just a URL+querystring
     *
     * @param string $url a whole url, querystring included.
     * @param string $http_method [optional, default=GET] http method
     * @param OAuth_Consumer $consumer [optional] consumer to sign with
     * @param OAuth_Token $token [optional] token to sign with
     * @return self
     */
    public static function fromUrl($url, $http_method = 'GET', $consumer = null, $token = null) {
        $parts = parse_url($url);
        $qs = array();
        parse_str($parts['query'], $qs);
        if (!$consumer) {
            return self::fromRequest($http_method, $url, $qs);
        } else {
            return self::fromConsumerAndToken($consumer, $token, $http_method, $url, $qs);
        }
    }

    /**
     * Create request from consumer and token as well (for a new request)
     *
     * @param OAuth_Consumer $consumer consumer
     * @param OAuth_Token $token token
     * @param string $http_method method
     * @param string $http_url url
     * @param array $parameters parameters
     * @return self
     */
    public static function fromConsumerAndToken(OAuth_Consumer $consumer, $token, $http_method, $http_url, $parameters) {
        @$parameters or $parameters = array();
        $defaults = array('oauth_version' => self::$version,
                          'oauth_nonce' => self::getNonce(),
                          'oauth_timestamp' => self::getTimestamp(),
                          'oauth_consumer_key' => $consumer->getKey());
        $parameters = array_merge($defaults, $parameters);
        
        if ($token) {
            $parameters['oauth_token'] = $token->getKey();
        }
        return new self($http_method, $http_url, $parameters);
    }

    /**
     * set a parameter
     *
     * @param string $name
     * @param string $value
     */
    public function setParameter($name, $value) {
        $this->parameters[$name] = $value;
    }
    
    /**
     * get a parameter
     *
     * @param string $name
     * @return string
     */
    public function getParameter($name) {
        if (!array_key_exists($name, $this->parameters)) return null;
        return $this->parameters[$name];
    }
    
    /**
     * Get parameters array
     *
     * @return array of key=>value
     */
    public function getParameters() {
        return $this->parameters;
    }
    
    /**
     * normalize input url
     *
     * @param string $url url to normalize
     * @return string normalized url
     */
    public static function getNormalizedHttpUrl($url) {
        $parts = parse_url($url);
        $port = '';
        if (array_key_exists('port', $parts) && $parts['port'] != '80') {
            $port = ':' . $parts['port'];
        }
        return $parts['scheme'] . '://' . $parts['host'] . $port . '/' . trim($parts['path'], '/'); 
    }

    /**
     * get HTTP url in this request (normalized)
     *
     * @return string
     */
    public function getHttpUrl() {
        return $this->http_url;
    }
    
    /**
     * get HTTP method in this request (normalized)
     *
     * @return unknown
     */
    public function getHttpMethod() {
        return $this->http_method;
    }
    
    /**
     * Build whole url for request
     *
     * @uses toPostdata()
     * @uses getHttpUrl()
     * @return string http://httpurl?parameters
     */
    public function toUrl() {
        $out = $this->getHttpUrl() . '?';
        $out .= $this->toPostdata();
        return $out;
    }

    /**
     * build querystring for post or get
     *
     * @return string param=value&param=value...
     */
    public function toPostdata() {
        return OAuth_Utils::normalizeKeyValueParameters($this->getParameters());
    }

    /**
     * Builds Authorization: header for request
     *
     * @return string Authorization: OAuth ...
     */
    public function toHeader() {
        $out = '"Authorization: OAuth realm="",';
        return $out . OAuth_Utils::normalizeKeyValueParameters($this->getParameters(), ',');
    }
    
    /**
     * gets url
     *
     * @uses toUrl()
     * @return string
     */
    public function __toString() {
        return $this->toUrl();
    }

    /**
     * Signs this request - adds parameters for signature method and the signed signature
     *
     * @param string $signature_method signing method identifier
     * @param OAuth_Consumer $consumer to sign against
     * @param OAuth_Token $token to sign against
     */
    public function signRequest($signature_method, OAuth_Consumer $consumer, $token = null) {
        if (!($method = OAuth_Signature::getSignatureMethod($signature_method))) return false;
        
        $this->setParameter('oauth_signature_method', $method->getMethodName());
        $consumer_secret = $consumer->getSecret();
        $token_secret = ($token) ? $token->getSecret() : '';
        
        $signature = $method->signRequest($this, $consumer_secret, $token_secret);
        $this->setParameter('oauth_signature', $signature);
    }

    /**
     * Get current timestamp
     *
     * @return int
     */
    public static function getTimestamp() {
        //return 1191242096; //example from spec
        return time();
    }

    /**
     * get current nonce
     *
     * @return string
     */
    public static function getNonce() {
        //return 'kllo9940pd9333jh'; //example from spec
        $mt = microtime();
        $rand = mt_rand();
        
        return md5($mt . $rand); // md5s look nicer than numbers
    }

    /**
    * util function for turning the Authorization: header into
    * parameters, has to do some unescaping
    * 
    * @param string $header string to split up
    * @return array array of oauth params
    */
    public static function splitHeader($header) {
        // error cases: commas in parameter values
        $parts = explode(',', $header);
        $out = array();
        foreach ($parts as $param) {
            $param = trim($param);
            // skip the 'realm' param, nobody ever uses it anyway
            if (substr($param, 0, 5) != 'oauth') continue;
            
            $param_parts = explode('=', $param);
            
            // rawurldecode() used because urldecode() will turn a '+' in the
            // value into a space
            $out[OAuth_Utils::urldecodeRFC3986($param_parts[0])] = OAuth_Utils::urldecodeRFC3986(trim($param_parts[1],'"'));
        }
        return $out;
    }
    
}
