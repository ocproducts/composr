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
 * OAuth Consumer representation
 *
 * @package OAuth
 */
class OAuth_Consumer {
    
    /**
     * Consumer Key string
     *
     * @var string
     */
    public $key;
    
    /**
     * Consumer Secret string
     *
     * @var string
     */
    public $secret;
    
    /**
     * Constructor
     *
     * @param string $key oauth_consumer_key
     * @param string $secret oauth_consumer_secret
     */
    public function __construct($key, $secret) {
        $this->key = $key;
        $this->secret = $secret;
    }
    
    /**
     * Magic function that shows who we are
     *
     * @return string key of consumer oauth_consumer_key
     */
    public function __toString() {
        return urlencode($this->getKey());
    }
    
    /**
     * Get the key
     *
     * @return string key of consumer oauth_consumer_key
     */
    public function getKey() {
        return $this->key;
    }
    
    /**
     * get the secret
     *
     * @return string secret of consumer oauth_consumer_secret
     */
    public function getSecret() {
        return $this->secret;
    }
    
}
