<?php
/**
 * Photobucket API 
 * Fluent interface for PHP5
 * Base methods
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
 * Base API methods
 *
 * @package PBAPI
 * @subpackage Methods
 */
class PBAPI_Methods_base extends PBAPI_Methods {

    /**
     * Ping
     *
     * @param array $params (anything)
     */
    public function ping($params = null) {
        if (!empty($params)) $this->core->_setParamList($params);
        $this->core->_setUri('/ping');
    }

    /**
     * search
     *
     * @param string $term search term, - for 'none' (recent)
     * @param array $params array(...)
     */
    public function search($term, $params = null) {
        if (!$term) $term = '-';

        $this->core->_setUri('/search/%s', $term);
        $this->core->_setParamList($params);

        $this->_load('search');
    }

    /**
     * findstuff
     *
     * @param string $term category name, - for 'none' (recent)
     * @param array $params array(...)
     */
    public function findstuff($cat = '', $params = null) {
        if (!$cat) $cat = '-';

        $this->core->_setUri('/findstuff/%s', $cat);
        $this->core->_setParamList($params);

        $this->_load('findstuff');
    }

    /**
     * Featured Media
     *
     */
    public function featured() {
        $this->core->_setUri('/featured');

        $this->_load('featured');
    }

    /**
     * User
     *
     * @param string $username [optional, default=current user token] username
     * @param array $params array(...)
     */
    public function user($username = '', $params = null) {
        if (is_array($username) && $params == null) {
            $params = $username;
            $username = '';
        }
        $this->core->_setUri('/user/%s', $username);
        $this->core->_setParamList($params);

        $this->_load('user');
    }

    /**
     * Album
     *
     * @param string $albumpath album path (username/location)
     * @param array $params array(...)
     */
    public function album($albumpath, $params = null) {
        if (!$albumpath) throw new PBAPI_Exception('albumpath required', $this->core);

        $this->core->_setUri('/album/%s', $albumpath);
        $this->core->_setParamList($params);

        $this->_load('album');
    }

    /**
     * GroupAlbum
     *
     * @param string $grouppath groupalbum path (grouphash/location)
     * @param array $params array(...)
     */
    public function group($grouppath, $params = null) {
        if (is_array($grouppath) && $params == null) {
            $params = $grouppath;
            $grouppath = '';
        }

        $this->core->_setUri('/group/%s', $grouppath);
        $this->core->_setParamList($params);

        $this->_load('group');
    }

    /**
     * Media
     *
     * @param string $mediaurl media url (http://i384.photobucket.com/albums/v000/username/location/filename.gif)
     * @param array $params array(...)
     */
    public function media($mediaurl, $params = null) {
        if (!$mediaurl) throw new PBAPI_Exception('mediaurl required', $this->core);

        $this->core->_setUri('/media/%s', $mediaurl);
        $this->core->_setParamList($params);

        $this->_load('media');
    }

    /**
     * Login
     *
     * @param string $step [request|access] step of web login/auth process (old, for backwards compat)
     * @param array $params array(...)
     */
    public function login($step='', $params = null) {
        if ($step) $this->core->_setUri('/login/%s', $step);
        else $this->core->_setUri('/login');

        $this->core->_setParamList($params);

        $this->_load('login');
    }

    /**
     * get accessor tokens 
     * 
     * @param array $params array(...)
     */
    public function accessor($params = null) {
        $this->core->_setUri('/accessor');
        $this->core->_setParamList($params);
    }

}
