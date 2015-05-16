<?php
/**
 * Photobucket API 
 * Fluent interface for PHP5
 * Response exception
 * 
 * @author Photobucket
 * @package PBAPI
 * @subpackage Exception
 * 
 * @copyright Copyright (c) 2008, Photobucket, Inc.
 * @license http://www.opensource.org/licenses/mit-license.php The MIT License
 */

/**
 * Response exceptions for the PBAPI
 *
 * @package PBAPI
 * @subpackage Exception
 */
class PBAPI_Exception_Response extends PBAPI_Exception {
    
    /**
     * Response magic tostring
     *
     * @return string
     */
    public function __toString() {
        $str = __CLASS__ . ' ('.$this->getCode().'): "' . $this->getMessage() . "\"\n"
        . 'Method: ' . implode(':',$this->getMethodStack()) . "\n"
        . 'Params: ';
        foreach ($this->getParams() as $k => $v) {
            $str .= "$k => $v, ";
        }
        return $str;
    } 
    
}
