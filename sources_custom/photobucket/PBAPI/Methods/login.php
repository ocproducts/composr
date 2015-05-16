<?php
/**
 * Photobucket API 
 * Fluent interface for PHP5
 * Login methods
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
 * Login submethods
 *
 * @package PBAPI
 * @subpackage Methods
 */
class PBAPI_Methods_login extends PBAPI_Methods {

    /**
     * Request
     *
     * @param array $params
     */
    public function request($params = null) {
        $this->core->_setParamList($params);
        $this->core->_appendUri('/request');
    }

    /**
     * Access
     *
     * @param array $params
     */
    public function access($params = null) {
        $this->core->_setParamList($params);
        $this->core->_appendUri('/access');
    }

}
