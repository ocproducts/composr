<?php
/**
 * Photobucket API 
 * Fluent interface for PHP5
 * Featured methods
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
 * Featured submethods
 *
 * @package PBAPI
 * @subpackage Methods
 */
class PBAPI_Methods_featured extends PBAPI_Methods {

    /**
     * Search Images
     *
     * @param array $params
     */
    public function homepage($params = null) {
        $this->core->_setParamList($params);
        $this->core->_appendUri('/homepage');
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

}
