<?php
/**
 * OAuth Request Signing
 * 
 * Adapted from Andy Smith's OAuth library for PHP
 * 
 * @link http://oauth.net/core/1.0
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
 * OAuth Request Signing
 *
 * @package OAuth
 */
class OAuth_Signature {
    
    /**
     * Get a signature method class
     *
     * @todo php5.3 make this happen static to the interface.
     * @param string $method OAuth signature method
     * @return OAuth_Signature_Interface
     */
    public static function getSignatureMethod($method) {
        //normalize method
        $method = OAuth_Utils::normalizeHashMethod($method);
        $class = 'OAuth_Signature_' . $method;
        if (!class_exists($class)) require_once(dirname(__FILE__).'/Signature/' . $method . '.php');
        
        return new $class();
    }
    
    /**
     * Sign a request
     *
     * @param string $method method name
     * @param OAuthRequest $request
     * @param string $consumer_secret
     * @param string $token_secret
     * @return string
     */
    public static function buildSignature($method, OAuth_Request $request, $consumer_secret, $token_secret = null) {
        return self::getSignatureMethod($method)->signRequest($request, $consumer_secret, $token_secret);
    }
    
}
