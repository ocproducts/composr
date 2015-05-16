<?php
/**
 * OAuth Utilities
 * 
 * Adapted from OAuthUtil from Hyves.net Beta API OAuthUtils to pass the test cases
 *
 * @link http://trac.hyves-api.nl/hyves-api/wiki/API09Examples#oAuthsigning
 * 
 * @package OAuth
 * 
 * @author jhart
 * @copyright Copyright (c) 2008, Photobucket, Inc.
 * @license http://www.opensource.org/licenses/mit-license.php The MIT License
 */

/**
 * OAuth Utilities methods
 *
 * @package OAuth
 */
class OAuth_Utils {
    
    /**
     * Takes an array of arrays 'keys' and 'vals', encodes them, and returns them as a string
     *
     * @uses urlencodeRFC3986()
     * @param array $splitparams array of two arrays with keys 'keys' and 'vals', e.g. array('keys'=>array('a'), 'vals'=>array('1'))) 
     * @param strin $delim delimiter between parameters (headers uses ',')
     * @return string delimited key=value string
     */
    public static function normalizeParameters($splitparams, $delim = '&') {
        array_multisort($splitparams['keys'], $splitparams['values']);
        $vars = array();
        for ($i=0; $i<count($splitparams['keys']); $i++) {
            $vars[] = self::urlencodeRFC3986($splitparams['keys'][$i]) 
                . '=' . self::urlencodeRFC3986($splitparams['values'][$i]);
        }
        return implode($delim, $vars);
    }
    
    /**
     * normalize array(key=>value, key=>value...) type of array and return the string
     *
     * @uses normalizeParameters()
     * @param array $params array of parameters in key=>value format
     * @param string $delim delimiter between parameters
     * @return string delimited key=value string
     */
    public static function normalizeKeyValueParameters($params, $delim = '&') {
        $karray = $varray = array();
        foreach($params as $k => $v) {
            $karray[] = $k;
            $varray[] = $v;
        }
        return self::normalizeParameters(array('keys' => $karray, 'values' => $varray), $delim);
    }
    
    /**
     * Encodes strings in an RFC3986 compatible encoding
     *
     * @param string $string
     * @return string
     */
    public static function urlencodeRFC3986($string) {
        return str_replace('%7E', '~', rawurlencode($string));
    }
    
    /**
     * Encodes UTF8 in RFC3986 encoding
     *
     * @uses urlencodeRFC3986()
     * @param string $string
     * @return string
     */
    public static function urlencodeRFC3986_UTF8($string) {
        return self::urlencodeRFC3986(utf8_encode($string));
    }
    
    /**
     * Decodes strings from RFC3986 encoding
     *
     * @param string $string
     * @return string
     */
    public static function urldecodeRFC3986($string) {
        return rawurldecode($string); // no exta stuff needed for ~, goes correctly automatically
    }
    
    /**
     * Decodes UTF8 in an RFC3986 encoded string
     *
     * @uses urldecodeRFC3986()
     * @param string $string
     * @return string
     */
    public static function urldecodeRFC3986_UTF8($string) {
        return utf8_decode(self::urldecodeRFC3986($string));
    }
    
    /**
     * normalize hash method name
     *
     * @param string $method
     * @return string
     */
    public static function normalizeHashMethod($method) {
        //make 'neat' for other areas of the library
        return strtolower(str_replace(array(' ', '-'), '_', $method));
    }
    
    /**
     * Filter parameters for things we shouldnt include in a basestring
     *
     * @return array
     */
    public static function getFilteredBaseStringParams($params) {
        //remove things that shouldnt end up in the hash
        if (!empty($params['oauth_signature'])) unset($params['oauth_signature']);
        return $params;
    }
    
    /**
     * PHP implementation of hash_hmac - supports sha1 and md5 in PHP5
     *
     * @param string $hashfunc name of hash function
     * @param string $string string to hash
     * @param string $key key to hash against
     * @param bool $raw [optional, default=false] return raw bits, or hex
     * @param int $blocksize [optional, default=64] blocksize to pad
     * @return string result of hash
     */
    public static function php_hash_hmac($hashfunc, $string, $key, $raw = false, $blocksize = 64) {
        if ($hashfunc != 'md5' && $hashfunc != 'sha1') return false;
        if (strlen($key) > $blocksize) $key = pack('H*', $hashfunc($key));
        $key = str_pad($key, $blocksize, chr(0));
        
        $ipad = str_repeat(chr(0x36), $blocksize);
        $opad = str_repeat(chr(0x5c), $blocksize);
        
        $ihash = pack('H*', $hashfunc(($key^$ipad) . $string));
        return $hashfunc(($key^$opad) . $ihash, $raw);
    }
    
}
