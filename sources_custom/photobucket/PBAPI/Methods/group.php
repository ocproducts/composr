<?php
/**
 * Photobucket API 
 * Fluent interface for PHP5
 * GroupAlbum methods
 * 
 * @author Photobucket
 * @package PBAPI
 * @subpackage Methods
 * 
 * @copyright Copyright Copyright (c) 2008, Photobucket, Inc.
 * @license http://www.opensource.org/licenses/mit-license.php The MIT License
 */

/**
 * Load Methods parent
 */
require_once(dirname(__FILE__).'/../Methods.php');

/**
 * GroupAlbum submethods
 *
 * @package PBAPI
 * @subpackage Methods
 */
class PBAPI_Methods_group extends PBAPI_Methods {

    /**
     * Upload File
     *
     * @param array $params
     */
    public function upload($params) {
        $this->core->_setParamList($params);
        $this->core->_appendUri('/upload');
    }

    /**
     * Privacy
     *
     * @param array $params
     */
    public function privacy($params = null) {
        $this->core->_setParamList($params);
        $this->core->_appendUri('/privacy');
    }

    /**
     * Vanity
     *
     * @param array $params
     */
    public function vanity($params = null) {
        $this->core->_setParamList($params);
        $this->core->_appendUri('/vanity');
    }

    /**
     * info 
     * 
     * @param array $params 
     */
    public function info($params = null) {
        $this->core->_setParamList($params);
        $this->core->_appendUri('/info');
    }

    /**
     * contributors 
     * 
     * @param string $username
     * @param array $params 
     */
    public function contributor($username = '', $params = null) {
        if (is_array($username) && $params == null) {
            $params = $username;
            $username = '';
        }
        $this->core->_appendUri('/contributor/%s', $username);
        $this->core->_setParamList($params);
    }

    /**
     * get Tags for a group
     *
     * @param string $tagname name of a single tag to get media for
     * @param array $params
     */
    public function tag($tagname = '', $params = null) {
        if (is_array($tagname) && $params == null) {
            $params = $tagname;
            $tagname = '';
        }
        $this->core->_appendUri('/tag/%s', $tagname);
        $this->core->_setParamList($params);
    }

    /**
     * subscribe 
     * 
     * @param mixed $subid 
     * @param array $params 
     */
    public function follow($subid = '', $params = null) {
        if (is_array($subid) && $params == null) {
            $params = $subid;
            $subid = '';
        }
        $this->core->_appendUri('/follow/%s', $subid);
        $this->core->_setParamList($params);
    }

    /**
     * theme 
     * 
     * @param array $params 
     */
    public function theme($params = null) {
        $this->core->_setParamList($params);
        $this->core->_appendUri('/theme');
    }

    /**
     * url 
     * 
     * @param array $params 
     */
    public function url($params = null) {
        $this->core->_setParamList($params);
        $this->core->_appendUri('/url');
    }

}
