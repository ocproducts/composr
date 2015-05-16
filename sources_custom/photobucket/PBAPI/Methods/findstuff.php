<?php
/**
 * Photobucket API 
 * Fluent interface for PHP5
 * Findstuff methods
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
 * Findstuff submethods
 *
 * @package PBAPI
 * @subpackage Methods
 */
class PBAPI_Methods_findstuff extends PBAPI_Methods {

    /**
     * Search Images
     *
     * @param array $params
     */
    public function category($params = null) {
        $this->core->_setParamList($params);
        $this->core->_appendUri('/category');
    }

}
