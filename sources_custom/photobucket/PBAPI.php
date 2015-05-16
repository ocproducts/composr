<?php
/**
 * Photobucket API 
 * Fluent interface for PHP5
 * 
 * @author jhart
 * @package PBAPI
 * 
 * @copyright Copyright (c) 2008, Photobucket, Inc.
 * @license http://www.opensource.org/licenses/mit-license.php The MIT License
 */

/**
 * Load Exceptions
 */
require_once(dirname(__FILE__).'/PBAPI/Exception.php');
/**
 * Load Response Exceptions
 */
require_once(dirname(__FILE__).'/PBAPI/Exception/Response.php');

/**
 * PBAPI Class
 * Main class for Photobucket API interaction
 * 
 * @package PBAPI
 */
class PBAPI {
    
    /**
     * Request object holder
     *
     * @var PBAPI_Request
     */
    protected $request;
    /**
     * Response parser holder
     *
     * @var PBAPI_Response
     */
    protected $response;
    /**
     * Methods classes holder
     *
     * @var PBAPI_Methods
     */
    protected $methods;
    
    /**
     * current method stack
     *
     * @var array
     */
    protected $method_stack = array();
    /**
     * Current parameter set
     *
     * @var array key->value pairs
     */
    protected $params = array();
    /**
     * Current URI
     *
     * @var string
     */
    protected $uri;
    
    /**
     * Current username
     *
     * @var string
     */
    protected $username = '';

    /**
     * Flag to not reset after method call 
     * 
     * @var bool
     */
    protected $noReset = false;
    
    /**
     * Method validation map
     *
     * @static
     * @var array
     */
    static $method_validation_map;
    
    /**
     * Class constructor
     * Sets up request, consumer and methods
     *
     * @param string $consumer_key OAuth consumer key (scid)
     * @param string $consumer_secret OAuth consumer secret (private key)
     * @param string $type [optional, default=determined] Request type (one of class names in PBAPI/Request/*)
     * @param string $subdomain [optional, default='api'] default subdomain to use in requests
     * @param string $default_format [optional, default='xml'] response format to receive from api
     * @param array $type_params [optional, default=none] Request class parameters
     */
    public function __construct($consumer_key, $consumer_secret, $type = null, $subdomain = 'api', $default_format = 'xml', $type_params = array()) {
        $this->_loadMethodClass('base');
        
        $this->setRequest($type, $subdomain, $default_format, $type_params);
        $this->setOAuthConsumer($consumer_key, $consumer_secret);
    }
    
    /////////////////////// Setup and Settings ///////////////////////
    
    /**
     * Set OAuth Token
     *
     * @param string $token oauth token
     * @param string $token_secret oauth secret
     * @param string $username [optional, default=nochange] username associated with this token
     * @return PBAPI $this Fluent reference to self
     * @throws PBAPI_Exception on missing request
     */
    public function setOAuthToken($token, $token_secret, $username = '') {
        if ($this->request) $this->request->setOAuthToken($token, $token_secret);
        else throw new PBAPI_Exception('Request missing - cannot set OAuth Token', $this);
        
        if ($username) $this->username = $username;
        return $this;
    }
    
    /**
     * Get OAuth Token
     *
     * @throws PBAPI_Exception on missing request
     */
    public function getOAuthToken() {
        if ($this->request) return $this->request->getOAuthToken();
        else throw new PBAPI_Exception('Request missing - cannot get OAuth Token', $this);
    }
    
    /**
     * Set OAuth Consumer info
     *
     * @param string $consumer_key OAuth consumer key (scid)
     * @param string $consumer_secret OAuth consumer secret (private key)
     * @return PBAPI $this Fluent reference to self
     * @throws PBAPI_Exception on missing request
     */
    public function setOAuthConsumer($consumer_key, $consumer_secret) {
        if ($this->request) $this->request->setOAuthConsumer($consumer_key, $consumer_secret);
        else throw new PBAPI_Exception('Request missing - cannot set OAuth Token', $this);
        
        return $this;
    }
    
    /**
     * Set current subdomain
     *
     * @param string $subdomain
     * @return PBAPI $this Fluent reference to self
     * @throws PBAPI_Exception on missing request
     */
    public function setSubdomain($subdomain) {
        if ($this->request) $this->request->setSubdomain($subdomain);
        else throw new PBAPI_Exception('Request missing - cannot set Subdomain', $this);
        
        return $this;
    }
    
    /**
     * Get current subdomain
     */
    public function getSubdomain() {
        if ($this->request) return $this->request->getSubdomain();
        else throw new PBAPI_Exception('Request missing - cannot get Subdomain', $this);
    }
    
    /**
     * Get oauth token username
     */
    public function getUsername() {
        return $this->username;
    }
    
    /**
     * Set response parser
     *
     * @param string $type [optional, default=none] type of response parser (one of PBAPI/Response/*)
     * @param array $params [optional, default=none] parameters to set up parser
     * @return PBAPI $this Fluent reference to self
     */
    public function setResponseParser($type = null, $params = array()) {
        $class = 'PBAPI_Response_'.$type;
        if (!class_exists($class)) require('PBAPI/Response/'.$type.'.php');
        $this->response = new $class($params);
        
        if (!$this->response) throw new PBAPI_Exception('Could not get Response Parser', $this);
        if (!$this->request) throw new PBAPI_Exception('Request missing - cannot set OAuth Token', $this);
        
        $this->request->setDefaultFormat($this->response->getFormat());
        return $this;
    }
    
    /**
     * Set request method
     *
     * @param string $type [optional, default=determined] Request type (one of class names in PBAPI/Request/*)
     * @param string $subdomain [optional, default='api'] default subdomain to use in requests
     * @param string $default_format [optional, default='xml'] response format to receive from api
     * @param array $type_params [optional, default=none] Request class parameters
     * @return PBAPI $this Fluent reference to self
     */
    public function setRequest($type = null, $subdomain = 'api', $default_format = 'xml', $request_params = array()) {
        if (!$type) $type = self::_detectRequestStrategy();
        $class = 'PBAPI_Request_'.$type;
        if (!class_exists($class)) require('PBAPI/Request/'.$type.'.php');
        $this->request = new $class($subdomain, $default_format, $request_params);
        return $this;
    }
    
    /**
     * Attempt to detect request strategy and set the type
     *
     * @return string
     */
    protected static function _detectRequestStrategy() {
        if (function_exists('curl_init')) return 'curl';
        if (ini_get('allow_url_fopen')) return 'fopenurl';
    }
    
    /**
     * Reset current data
     *
     * @param bool $uri [optional] reset URI data
     * @param bool $methods [optional] reset method data (current method depth)
     * @param bool $params [optional] reset all parameters
     * @param bool $auth [optional] reset auth token
     * @return PBAPI $this Fluent reference to self
     */
    public function reset($uri = true, $methods = true, $params = true, $auth = false) {
        if ($uri) $this->uri = null;
        if ($methods) {
            $this->methods->_reset();
            $this->method_stack = array();
        }
        if ($params) $this->params = array();
        if ($auth && $this->request) $this->request->resetOAuthToken();
        return $this;
    }

    /**
     * Set No Reset Flag 
     * 
     * @param bool $set 
     * @return PBAPI $this Fluent reference to self
     */
    public function setNoReset($set) {
        $this->noReset = $set;
        return $this;
    }

    /////////////////////// Requests and Responses ///////////////////////
    
    /**
     * Get current parameters
     *
     * @return array current parameter key->values
     */
    public function getParams() {
        return $this->params;
    }
    
    /**
     * Get parsed response (from response parser)
     *
     * @param bool $onlycontent only return 'content' of response
     * @return mixed
     * @throws PBAPI_Exception on no response parser
     * @throws PBAPI_Exception_Response on response exception
     */
    public function getParsedResponse($onlycontent = false) {
        if (!$this->response) throw new PBAPI_Exception('No response parser set up', $this); 
        
        try {
            return $this->response->parse(trim($this->response_string), $onlycontent);
        } catch (PBAPI_Exception_Response $e) {
            //set core into exception
            throw new PBAPI_Exception_Response($e->getMessage(), $e->getCode(), $this); 
        }
    }
    
    /**
     * Get raw response string
     *
     * @return string
     */
    public function getResponseString() {
        return $this->response_string;
    }
    
    /**#@+
     * Forward current set up request to the request method and get back the response
     *
     * @return PBAPI $this Fluent reference to self
     */
    public function get() {
        $this->_validateRequest('get');
        $this->_setResponse($this->request->get($this->uri, $this->params));
        if (!$this->noReset) $this->reset();
        return $this;
    }
    public function post() {
        $this->_validateRequest('post');
        $this->_setResponse($this->request->post($this->uri, $this->params));
        if (!$this->noReset) $this->reset();
        return $this;
    }
    public function put() {
        $this->_validateRequest('put');
        $this->_setResponse($this->request->put($this->uri, $this->params));
        if (!$this->noReset) $this->reset();
        return $this;
    }
    public function delete() {
        $this->_validateRequest('delete');
        $this->_setResponse($this->request->delete($this->uri, $this->params));
        if (!$this->noReset) $this->reset();
        return $this;
    }
    /**#@-*/
    
    /**
     * Load and set the current OAuth token from the last response string
     *
     * @param bool $subdomain true if you want to also set the current default call subdomain to what is in the response.
     * @return PBAPI $this Fluent reference to self
     */
    public function loadTokenFromResponse($subdomain = true) {
        $string = trim($this->response_string);
        $params = array();
        parse_str($string, $params);
        if (empty($params) || empty($params['oauth_token']) || empty($params['oauth_token_secret'])) {
            throw new PBAPI_Exception('Token and Token Secret not returned in response');
        }
        
        $username = (!empty($params['username'])) ? $params['username'] : '';
        $this->setOAuthToken($params['oauth_token'], $params['oauth_token_secret'], $username);
        if ($subdomain && !empty($params['subdomain'])) {
            $this->setSubdomain($params['subdomain']);
        }
        return $this;
    }
    
    /**
     * Go to Redirect URL
     * does actual header()
     *
     * @param string $type [login|logout|...]
     * @param string $extra [optional] set 'extra' parameter
     * @throws PBAPI_Exception on invalid redirect
     */
    public function goRedirect($type = null, $extra = null) {
        if (strpos($type, 'http://') !== 0) {
            switch ($type) {
                case 'login': $this->request->redirectLogin($extra);
                case 'logout': $this->request->redirectLogout($extra);
                default: throw new PBAPI_Exception('Invalid redirect', $this);
            }
        } else {
            if ($extra) {
                $sep = (strpos($type,'?')) ? '&' : '?';
                $url = $type . $sep . 'extra='.$extra;
            } else {
                $url = $type;
            }
            header('Location: '.$url);
            exit;
        }
    }

    /////////////////////// Inter Class 'Private' Methods ///////////////////////
    
    /**
     * Set a parameter
     *
     * @param string $name
     * @param string $value
     * @return PBAPI $this Fluent reference to self
     */
    public function _setParam($name, $value) {
        $this->params[$name] = $value;
        return $this;
    }
    
    /**
     * Set a list of parameters
     *
     * @param array $pairs parameters as key=>value (allowing empty)
     * @return PBAPI $this Fluent reference to self
     */
    public function _setParamList($pairs) {
        if (!$pairs) return $this;
        foreach ($pairs as $name => $value) {
            $this->_setParam($name, $value);
        }
        return $this;
    }
    
    /**
     * Set current URI
     *
     * @param string $uri uri string to set, sprintf format
     * @param array $replacements [optional, default=none] if uri is sprintf string, replacements from this array in array order
     * @return PBAPI $this Fluent reference to self
     */
    public function _setUri($uri, $replacements = null) {
        if ($replacements !== null && !is_array($replacements)) $replacements = array($replacements);
        if ($replacements !== null) {
            $replacements = array_map('urlencode', $replacements);
            $this->uri = vsprintf($uri, $replacements);
        }
        else $this->uri = $uri;
        return $this;
    }
    
    /**
     * Append more to the current uri
     *
     * @param string $uri uri string to set, sprintf format
     * @param array $replacements [optional, default=none] if uri is sprintf string, replacements from this array in array order
     * @return PBAPI $this Fluent reference to self
     */
    public function _appendUri($uri, $replacements = null) {
        if ($replacements !== null && !is_array($replacements)) $replacements = array($replacements);
        if ($replacements !== null) {
            $replacements = array_map('urlencode', $replacements);
            $this->uri .= vsprintf($uri, $replacements);
        }
        else $this->uri .= $uri;
        return $this;
    }
    
    /**
     * Load a method class
     *
     * @param string $name Method class name (one of PBAPI/Methods/*)
     * @return PBAPI_Methods
     */
    public function _loadMethodClass($name) {
        $class = 'PBAPI_Methods_' . $name;
        if (!class_exists($class)) require_once(dirname(__FILE__).'/PBAPI/Methods/'.$name.'.php');
        $classObj = new $class($this);
        return $this->_setMethods($classObj);
    }
    
    /**
     * Set Methods class
     * 
     * @param PBAPI_Methods $class class instance
     * @return PBAPI $this Fluent reference to self
     */
    public function _setMethods($class) {
        $this->methods = $class;
        return $this;
    }
    
    /**
     * Get parameters currently in obj
     *
     * @return array key->value
     */
    public function _getParams() {
        return $this->params;
    }
    
    /**
     * Get method stack - this is the level list of the method
     *
     * @return array methods list (in call order)
     */
    public function _getMethodStack() {
        return $this->method_stack;
    }
    
    /**
     * Set the current response string
     *
     * @param string $string
     * @return PBAPI $this Fluent reference to self
     */
    protected function _setResponse($string) {
        $this->response_string = $string;
        return $this;
    }
    
    /**
     * Validate Request (as currently set)
     *
     * $dt = syck_load(file_get_contents('api-defs.yml'));
     * file_put_contents('methods.dat', serialize($dt));
     *
     * @param string $method HTTP method to check against
     * @return PBAPI $this Fluent reference to self
     * @throws PBAPI_Exception method or parameters don't match presets
     */
    protected function _validateRequest($method) {
        //get proper map
        $map = $this->_loadMethodValidationMap();
        
        //fixup stack
        $stack = $this->method_stack;
        if (empty($stack[1])) $stack[1] = '_default';
        
        //get method
        $val_methods = $map[$stack[0]][$stack[1]];
        if (!$val_methods || !array_key_exists($method, $val_methods)) throw new PBAPI_Exception('invalid method: '.$method, $this);
        
        //get parameters
        $val_params = $val_methods[$method];
        if ($val_params) {
            //look for unknown parameters (if parameters are specified)
            $unknowns = array_diff_key($this->params, $val_params);
            //unknown params are a warning.
            if (count($unknowns)) trigger_error('unknown parameters: ' . implode(', ', array_keys($unknowns)), E_USER_WARNING);
            
            //look for missing required parameters
            $missing = array_diff_key($val_params, $this->params);
            if (count($missing)) {
                foreach ($missing as $key=>$val) {
                    if ($val != 'required') unset($missing[$key]);
                    if ($key == 'aid' || $key == 'mid' || $key == 'uid' || $key == 'tagid') //todo somehow do this better 
                        unset($missing[$key]); //also skip stuff we're catching already
                }
                if (count($missing)) throw new PBAPI_Exception('missing required parameters: ' . implode(', ', array_keys($missing)), $this);
            }
        }
        return $this;
    }
    
    /**
     * Load validation map from data file
     * Loads from ./PBAPI/data/methods.dat - a php serialize() file.
     * The .yml file in the same directory is the 'source' of that dat file.
     *
     * @return array validation map from data file
     */
    protected function _loadMethodValidationMap() {
        if (!self::$method_validation_map) {
            $path = dirname(__FILE__) . '/PBAPI/data/methods.dat';
            self::$method_validation_map = unserialize(file_get_contents($path));
            if (!self::$method_validation_map) throw new PBAPI_Exception('Could not load method map', $this);
        }
        return self::$method_validation_map;
    }
    
    /////////////////////// Magics ///////////////////////
    
    /**
     * Magic function to forward other calls to the Methods
     * This is the meat of the API, really
     *
     * @param string $name function name
     * @param array $args argument array
     * @return PBAPI $this Fluent reference to self
     */
    public function __call($name, $args) {
        if (empty($args)) {
            $this->methods->$name();
        } else if (!empty($args[0]) && empty($args[1])) {
            $this->methods->$name($args[0]);
        } else if (!empty($args[0]) && !empty($args[1])) {
            $this->methods->$name($args[0], $args[1]);
        } else {
            //not currently used, but for forward compatibility
            call_user_func_array(array($this->methods, $name), $args);
        }
        
        $this->method_stack[] = $name;
        return $this;
    }
    
}
