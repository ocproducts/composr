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
 * @subpackage Signature
 * 
 * @author jhart
 * @copyright Copyright (c) 2008, Photobucket, Inc.
 * @license http://www.opensource.org/licenses/mit-license.php The MIT License
 */

/**
 * interface
 */
require_once(dirname(__FILE__).'/Interface.php');

/**
 * OAuth HMAC-SHA1 implementation
 *
 * @package OAuth
 * @subpackage Signature
 */
class OAuth_Signature_hmac_sha1 implements OAuth_Signature_Interface {
    
    /**
     * Representation string
     *
     */
    const OAUTH_SIGNATURE_METHOD = 'HMAC-SHA1';
    
    /**
     * Sign a request
     *
     * @param OAuth_Request $request request to sign
     * @param string $consumer_secret consumer secret key
     * @param string $token_secret token secret key
     * @return string calculated hash for request, secrets
     */
    public function signRequest(OAuth_Request $request, $consumer_secret, $token_secret = '') {
        $basestr = self::generateBaseString(
            $request->getHttpMethod(), 
            $request->getHttpUrl(), 
            OAuth_Utils::normalizeKeyValueParameters(OAuth_Utils::getFilteredBaseStringParams($request->getParameters()))
            );
        //for debug purposes
        $request->base_string = $basestr;
        
        $keystr = self::generateKeyString($consumer_secret, $token_secret);
        //for debug purposes
        $request->key_string = $keystr;
        
        return self::calculateHash($basestr, $keystr);
    }
    
    /**
     * Get the OAuth official string representation for this method
     *
     * @return string oauth method name
     */
    public function getMethodName() {
        return self::OAUTH_SIGNATURE_METHOD;
    }
    
    /**
     * Creates the basestring needed for signing per oAuth Section 9.1.2
     * All strings are latin1
     *
     * @todo could be in a base class for hmac
     * @uses urlencodeRFC3986()
     * @param string $http_method one of the http methods GET, POST, etc.
     * @param string $uri the uri; the url without querystring
     * @param string $params normalized parameters as returned from OAuthUtil::normalizeParameters
     * @return string concatenation of the encoded parts of the basestring
     */
    protected static function generateBaseString($http_method, $uri, $params) {
        return OAuth_Utils::urlencodeRFC3986($http_method)
            . '&' . OAuth_Utils::urlencodeRFC3986($uri)
            . '&' . OAuth_Utils::urlencodeRFC3986($params);
    }
    
    /**
     * Generate a key string
     * 
     * @todo could be in a base class for hmac
     * @param string $consumersecret consumer secret key
     * @param string $tokensecret token secret key
     * @return string single key string
     */
    protected static function generateKeyString($consumersecret, $tokensecret = '') {
        return OAuth_Utils::urlencodeRFC3986($consumersecret) 
            . '&' . OAuth_Utils::urlencodeRFC3986($tokensecret);
    }
    
    /**
     * Calculates the HMAC-SHA1 secret
     *
     * @uses urlencodeRFC3986()
     * @param string $basestring gotten from generateBaseString
     * @param string $consumersecret
     * @param string $tokensecret leave empty if no token present
     * @return string base64 encoded signature
     */
    protected static function calculateHash($basestring, $key) {
        return base64_encode(self::hash_hmac_sha1($basestring, $key, true));
    }
    
    /**
     * run hash_hmac with sha1 (package independant)
     *
     * @uses php_hash_hmac
     * @param string $string string to hash
     * @param string $key key to hash against
     * @return string result of hash
     */
    protected static function hash_hmac_sha1($string, $key, $raw = true) {
        if (function_exists('hash_hmac')) {
           return hash_hmac('sha1', $string, $key, $raw);
        } else {
            return OAuth_Utils::php_hash_hmac('sha1', $string, $key, $raw);
        }
    }
    
}
