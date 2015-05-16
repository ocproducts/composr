<?php
/**
 * Photobucket API 
 * Fluent interface for PHP5
 * Media methods
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
 * Media methods
 *
 * @package PBAPI
 * @subpackage Methods
 */
class PBAPI_Methods_media extends PBAPI_Methods {

    /**
     * description
     *
     * @param array $params
     */
    public function description($params = null) {
        $this->core->_setParamList($params);
        $this->core->_appendUri('/description');
    }

    /**
     * Title
     *
     * @param array $params
     */
    public function title($params = null) {
        $this->core->_setParamList($params);
        $this->core->_appendUri('/title');
    }

    /**
     * Tag
     *
     * @param int $tagid [optional, default=all] tag id, '' for all tags
     * @param array $params array(...)
     */
    public function tag($tagid = '', $params = null) {
        if (is_array($tagid) && $params == null) {
            $params = $tagid;
            $tagid = '';
        }
        $this->core->_appendUri('/tag/%s', $tagid);
        $this->core->_setParamList($params);
    }

    /**
     * resize
     *
     * @param array $params
     */
    public function resize($params) {
        $this->core->_setParamList($params);
        $this->core->_appendUri('/resize');
    }

    /**
     * Rotate
     *
     * @param array $params
     */
    public function rotate($params) {
        $this->core->_setParamList($params);
        $this->core->_appendUri('/rotate');
    }

    /**
     * Metadata
     *
     * @param array $params
     */
    public function meta($params = null) {
        $this->core->_appendUri('/meta');
    }

    /**
     * Links
     *
     * @param array $params
     */
    public function links($params = null) {
        $this->core->_appendUri('/link');
    }

    /**
     * related search
     *
     * @param array $params
     */
    public function related($params = null) {
        $this->core->_setParamList($params);
        $this->core->_appendUri('/related');
    }

    /**
     * Share
     *
     * @param array $params
     */
    public function share($params) {
        $this->core->_setParamList($params);
        $this->core->_appendUri('/share');
    }

    /**
     * comment
     *
     * @param array $params
     */
    public function comment($params=null) {
        $this->core->_setParamList($params);
        $this->core->_appendUri('/comment');
    }

    /**
     * rating
     *
     * @param array $params
     */
    public function rating($params=null) {
        $this->core->_setParamList($params);
        $this->core->_appendUri('/rating');
    }

    /**
     * geo 
     * 
     * @param array $params 
     */
    public function geo($params=null) {
        $this->core->_setParamList($params);
        $this->core->_appendUri('/geo');
    }


}
