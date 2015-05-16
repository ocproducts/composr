<?php
/**
 * Photobucket API 
 * Fluent interface for PHP5
 * Album methods
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
 * Album submethods
 *
 * @package PBAPI
 * @subpackage Methods
 */
class PBAPI_Methods_album extends PBAPI_Methods {

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
     * organize 
     * 
     * @param array $params 
     */
    public function organize($params = null) {
        $this->core->_setParamList($params);
        $this->core->_appendUri('/organize');
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
