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
 * OAuth PLAINTEXT implementation
 *
 * @package OAuth
 * @subpackage Signature
 */
class OAuth_Signature_plaintext implements OAuth_Signature_Interface {
    
    /**
     * Representation string
     *
     */
    const OAUTH_SIGNATURE_METHOD = 'PLAINTEXT';
    
    /**
     * Sign a request
     *
     * @param OAuth_Request $request request to sign
     * @param string $consumer_secret consumer secret key
     * @param string $token_secret token secret key
     * @return string calculated hash for request, secrets
     */
    public function signRequest(OAuth_Request $request, $consumer_secret, $token_secret = '') {
        // for debug purposes
        $request->base_string = '';
        
        $key = self::generateKeyString($consumer_secret, $token_secret);
        //for debug purposes
        $request->key_string = $key;
        
        return OAuth_Utils::urlencodeRFC3986($key);
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
     * Generate a key string
     * 
     * @todo could be in a base class for hmac
     * @param string $consumersecret consumer secret key
     * @param string $tokensecret token secret key
     * @return string single key string
     */
    protected static function generateKeyString($consumersecret, $tokensecret = '') {
        return OAuth_Utils::urlencodeRFC3986($consumersecret) 
            . '&' . self::urlencodeRFC3986($tokensecret);
    }
    
}
