<?php
/**
 * Photobucket API 
 * Fluent interface for PHP5
 * Search methods
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
 * Search submethods
 *
 * @package PBAPI
 * @subpackage Methods
 */
class PBAPI_Methods_search extends PBAPI_Methods {

    /**
     * Search Images
     *
     * @param array $params
     */
    public function image($params = null) {
        $this->core->_setParamList($params);
        $this->core->_appendUri('/image');
    }

    /**
     * Search Video
     *
     * @param array $params
     */
    public function video($params = null) {
        $this->core->_setParamList($params);
        $this->core->_appendUri('/video');
    }

    /**
     * Search Group
     *
     * @param array $params
     */
    public function group($params = null) {
        $this->core->_setParamList($params);
        $this->core->_appendUri('/group');
    }

    /**
     * follow 
     * 
     * @param mixed $subid 
     * @param array $params 
     */
    public function follow($subid='', $params = null) {
        if (is_array($subid) && $params == null) {
            $params = $subid;
            $subid = '';
        }
        $this->core->_appendUri('/follow/%s', $subid);
        $this->core->_setParamList($params);
    }

}
