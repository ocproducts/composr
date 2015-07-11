<?php /*

 Composr
 Copyright (c) ocProducts, 2004-2015

 See text/EN/licence.txt for full licencing information.

*/

/**
 * @license    http://opensource.org/licenses/cpal_1.0 Common Public Attribution License
 * @copyright  ocProducts Ltd
 * @package    cns_tapatalk
 */
abstract class MobiquoServer
{
    /**
     * Decode parameters we were called with.
     *
     * @param  mixed            Raw params
     * @return array Params as an array
     */
    abstract function params_decode($raw_params);

    /**
     * Dispatch a server request.
     */
    abstract function dispatch_request();

    /**
     * Wrap a value for the particular MobiquoServer server implementation.
     *
     * @param  mixed            Data
     * @param  string            Type
     * @set string boolean base64 int dateTime.iso8601 array struct
     * @return mixed Mobiquo result
     */
    abstract function val($data, $type);

    /**
     * Wrap a result for the particular MobiquoServer server implementation.
     *
     * @param  mixed            Data
     * @return mixed Mobiquo response
     */
    abstract function response($data);

    /**
     * Output a response.
     *
     * @param  mixed            Response
     */
    function output_response($response)
    {
        echo $response;
    }
}

