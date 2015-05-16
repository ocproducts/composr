#!/usr/bin/env php
<?php
/**
 * Photobucket API 
 * Fluent interface for PHP5
 * 
 * Requires syck parser to turn yml into php array
 * 
 * @author Photobucket
 * @package PBAPI
 * @subpackage data
 * 
 * @copyright Copyright (c) 2008, Photobucket, Inc.
 * @license http://www.opensource.org/licenses/mit-license.php The MIT License
 */

$dt = syck_load(file_get_contents('api-defs.yml'));
var_dump($dt);
file_put_contents('methods.dat', serialize($dt));
