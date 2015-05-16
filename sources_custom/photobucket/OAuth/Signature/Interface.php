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
 * OAuth Signature Method Interface
 *
 * @package OAuth
 * @subpackage Signature
 */
interface OAuth_Signature_Interface {
    
    //const OAUTH_SIGNATURE_METHOD;
    
    /**
     * Sign a request
     *
     * @param OAuth_Request $request request to sign
     * @param string $consumer_secret consumer secret key
     * @param string $token_secret token secret key
     * @return string signature hash string
     */
    public function signRequest(OAuth_Request $request, $consumer_secret, $token_secret = '');
    
    /**
     * Get the OAuth official string representation for this method
     *
     * @return string oauth method name
     */
    public function getMethodName();
    
}