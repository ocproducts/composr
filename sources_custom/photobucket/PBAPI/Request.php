<?php
/**
 * Photobucket API 
 * Fluent interface for PHP5
 * Request parent class
 * 
 * @author jhart
 * @package PBAPI
 * 
 * @copyright Copyright (c) 2008, Photobucket, Inc.
 * @license http://www.opensource.org/licenses/mit-license.php The MIT License
 */

/**
 * Require OAuth Request Obj
 */
require_once(dirname(__FILE__).'/../OAuth/Request.php');

/**
 * Request method parent class
 *
 * @package PBAPI
 */
abstract class PBAPI_Request {
    
    /**
     * Oauth consumer object
     *
     * @var OAuth_Consumer
     */
    private $oauth_consumer;
    /**
     * Oauth token object
     *
     * @var OAuth_Token
     */
    private $oauth_token;
    
    /**
     * Current subdomain
     *
     * @var string
     */
    protected $subdomain;
    /**
     * Default format id
     *
     * @var string
     */
    protected $default_format;
    
    /**
     * Full request URL (for debugging)
     *
     * @var string
     */
    public $request_url;
    /**
     * Oauth Request object (for debugging)
     *
     * @var OAuthRequest
     */
    public $oauth_request;
    
    /**
     * Request strategy parameters
     * 
     * @var array
     */
    protected $request_params = array();
    
    /**
     * Photobucket Web Login url
     *
     * @static
     * @var string
     */
    public static $web_login_url = 'http://photobucket.com/apilogin/login';

    /**
     * current redirect depth tracking 
     * 
     * @var int
     */
    protected $redirect_depth = 0;
    /**
     * class maximum redirects 
     * @var int
     */
    const MAX_REDIRECTS = 3;
    
    /**
     * Class Constructor
     *
     * @param array $request_parameters parameters send to set in this object
     * @param string $subdomain default subdomain
     * @param string $default_format default format
     */
    public function __construct($subdomain = 'api', $default_format = 'xml', $request_params = array()) {
        $this->setSubdomain($subdomain);
        $this->setDefaultFormat($default_format);
        $this->setRequestParams($request_params);
    }
    
    /**
     * Set OAuth Consumer information
     *
     * @param string $consumer_key
     * @param string $consumer_secret
     */
    public function setOAuthConsumer($consumer_key, $consumer_secret) {
        $this->oauth_consumer = new OAuth_Consumer($consumer_key, $consumer_secret);
    }
    
    /**
     * Set OAuth Token info
     *
     * @param string $token
     * @param string $token_secret
     */
    public function setOAuthToken($token, $token_secret) {
        $this->oauth_token = new OAuth_Token($token, $token_secret);
    }
    
    /**
     * Set OAuth Token Object
     *
     * @param oAuth_Token $oauth_token
     */
    public function setOAuthTokenObject(OAuth_Token $oauth_token) {
        $this->oauth_token = $oauth_token;
    }
    
    /**
     * Get OAuth Token info
     *
     * return OAuth_Token
     */
    public function getOAuthToken() {
        return $this->oauth_token;
    }
    
    /**
     * clear oauth token
     *
     */
    public function resetOAuthToken() {
        $this->oauth_token = null;
    }
    
    /**
     * set subdomain value
     *
     * @param string $subdomain
     */
    public function setSubdomain($subdomain) {
        $subdomain = preg_replace('#\.photobucket\.com(/.*)?$#','',$subdomain);
        $this->subdomain = $subdomain;
    }
    
    /**
     * get subdomain value
     * 
     * @return string subdomain
     */
    public function getSubdomain() {
        return $this->subdomain;
    }
    
    /**
     * get whole subdomain url
     *
     * @param string $uri uri ending
     * @return string http://...
     */
    public function getSubdomainUrl($uri) {
        return 'http://'.$this->subdomain.'.photobucket.com/' . trim($uri, '/');
    }
    
    /**
     * set default response format
     *
     * @param string $format
     */
    public function setDefaultFormat($format) {
        //todo verify allowed formats
        $this->default_format = $format;
    }
    
    /**
     * Request params
     * 
     * @param array $params request params
     */
    public function setRequestParams($params) {
        $this->request_params = $params;
    }
    
    /**
     * Get OAuthRequest for given items
     *
     * @param string $method HTTP method
     * @param string $uri URI (no http/host)
     * @param array $params key=>value parameters
     * @return OAuthRequest
     */
    protected function getSignedOAuthRequest($method, $uri, array $params) {
        $req = OAuth_Request::fromConsumerAndToken($this->oauth_consumer, $this->oauth_token, 
            $method, 'http://api.photobucket.com/' . trim($uri, '/'), $params);
        $req->signRequest('HMAC-SHA1', $this->oauth_consumer, $this->oauth_token);
        return $req;
    }
    
    /**
     * Pre-Request filter
     *
     * @param string $method (ref) HTTP method
     * @param string $uri URI (no http://)
     * @param array $params parameters
     * @return string finished request url
     */
    protected function preRequest(&$method, &$uri, array &$params) {
        //cleanup method
        $method = strtoupper($method);
        
        //cleanup/determine format
        if ($this->default_format && !array_key_exists('format', $params)) {
            $params['format'] = $this->default_format;
        }
        
        //block uploadfile from parameters
        $uploadfile = null;
        if (!empty($params['uploadfile'])) {
            $uploadfile = $params['uploadfile'];
            unset($params['uploadfile']);
        }
        
        //get fullly signed request
        $req = $this->getSignedOAuthRequest($method, $uri, $params);
        
        $url = '';
        $params = array();
        
        //rebuild url and request with uploadfile
        if ($method != 'POST') {
            $url = $this->getSubdomainUrl($uri) .'?'. $req->toPostdata(); 
        } else {
            $url = $this->getSubDomainUrl($uri);
            if ($uploadfile) {
                $req->setParameter('uploadfile', $uploadfile);
            }
            $params = $req->getParameters();
        }
        
        $this->request_url = $url;
        $this->oauth_request = $req;
        return $url;
    }
    
    /**
     * Redirect to the login page (for given token)
     *
     * @param string $extra optional extra parameter to pass along (if you need to store a key without a cookie, for example)
     */
    public function redirectLogin($extra = null) {
        if (!$this->oauth_token || self::getOAuthTokenType($this->oauth_token) != 'req') {
            throw new PBAPI_Exception('OAuth Token is not a request token');
        }
        $req = $this->oauth_token->getKey();
        
        $url = self::$web_login_url . '?oauth_token=' . $req;

        if ($extra) $url .= '&extra='.$extra;

        header('Location: '.$url);
        exit;
    }

    /**#@+
     * Request function
     *
     * @param string $uri
     * @param array $params
     */
    public function get($uri, $params = array()) {
        return $this->request('GET', $uri, $params);
    }
    public function post($uri, $params = array()) {
        return $this->request('POST', $uri, $params);
    }
    public function put($uri, $params = array()) {
        return $this->request('PUT', $uri, $params);
    }
    public function delete($uri, $params = array()) { 
        return $this->request('DELETE', $uri, $params);
    }
    /**#@-*/
    
    /**
     * Actual Request function
     *
     * @param string $method
     * @param string $uri
     * @param array $params
     * @return string
     */
    protected function request($method, $uri, $params = array()) {
        //do oauth signing, preperation, etc.
        $url = $this->preRequest($method, $uri, $params);

        //do actual request method
        return $this->raw_request($method, $url, $params);
    }

    /**
     * Raw HTTP requst via class method
     * 
     * @param string $method GET/PUT/POST/DELETE method
     * @param string $url full http:// url to request against
     * @param array $params original(?) list of params
     * @return string response from API (raw, unparsed)
     */
    abstract protected function raw_request($method, $url, $params = array());
    
    /**
     * Turn parameters into multipart encoded string
     *
     * @param array $params key value pairs of parameters
     * @param string $bound boundary (should be relatively unique)
     * @return string mime type multipart-form 
     */
    public static function multipartEncodeParams(array $params, $bound) {
        $bound = '--'.trim($bound)."\n";
        $result = '';
        $paramStr = array();
        
        foreach ($params as $key => $val) {
            $file = false;
            
            if (strpos($val, '@') === 0) {
                $filepath = trim($val,'@');
                $val = file_get_contents($filepath);
                $disp = 'content-disposition: form-data; name="'.$key.'"; filename="'.basename($filepath).'"'."\n";
                $mimetype = 'mimetype';
                $disp .= 'content-type: ' . $mimetype . "\n";
                $disp .= 'content-transfer-encoding: binary'."\n";
            } else {
                $disp = 'content-disposition: form-data; name="'.$key.'"'."\n";
            }
            
            $paramStr[] = $disp."\n".$val."\n";
        }
        
        $result = $bound . implode($bound, $paramStr) . $bound;
        return $result;
    }
    
    /**
     * See if the given array has an upload filename as a parameter
     *
     * @param array $params parameters
     * @return bool array has at least one upload filename parameter
     */
    public static function detectFileUploadParams($params = array()) {
        foreach ($params as $p) {
            if (strpos($p, '@') === 0) return true;
        }
        return false;
    }
    
    /**
     * Determine an OAuth_Token's type
     *
     * @param OAuth_Token $token
     * @return string type of token [req|user]
     */
    public static function getOAuthTokenType(OAuth_Token $token) {
        if (!$token) return false;
        if (strpos($token->getKey(), 'req_') === 0) $type = 'req';
        else $type = 'user';
        return $type;
    }
    
}
