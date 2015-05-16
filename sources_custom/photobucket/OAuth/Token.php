<?php
/**
 * OAuth Model objects
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
 * OAuth Token representation
 *
 * @package OAuth
 */
class OAuth_Token {
    
    /**
     * Token key
     *
     * @var string oauth_token
     */
    public $key;
    
    /**
     * Token secret
     *
     * @var string oauth_token_secret
     */
    public $secret;
    
    /**
     * Constructor
     *
     * @param string $key oauth_token
     * @param string $secret oauth_token_secret
     */
    public function __construct($key, $secret) {
        $this->key = $key;
        $this->secret = $secret;
    }

    /**
     * Returns postdata representation of the token
     *
     * @return string postdata and OAuth Standard representation
     */
    public function __toString() {
        return 'oauth_token=' . urlencode($this->getKey()) 
        . '&oauth_token_secret=' . urlencode($this->getSecret());
    }
    
    /**
     * get key
     *
     * @return string oauth_token
     */
    public function getKey() {
        return $this->key;
    }
    
    /**
     * get token
     *
     * @return string oauth_token_secret
     */
    public function getSecret() {
        return $this->secret;
    }
    
}
