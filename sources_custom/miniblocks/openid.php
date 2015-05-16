<?php

i_solemnly_declare(I_UNDERSTAND_SQL_INJECTION | I_UNDERSTAND_XSS | I_UNDERSTAND_PATH_INJECTION);

require_css('openid');
require_javascript('jquery');
require_javascript('openid');

$url = build_url(array('page' => ''), '');
echo '
    <script>// <![CDATA[
    add_event_listener_abstract(window,\'load\',function() {
        $(function() {
          $("#openid").openid({
            img_path: "{{ MEDIA_URL }}img/openid/",
            txt: {
              label: "Enter your {username} for <b>{provider}<\/b>",
              username: "username",
              title: "Select where you\'d like to log in from.",
              sign: "log in"
            }
          });
        });
    } );
    //]]></script>

    <form title="OpenID (manually)" method="post" action="' . escape_html($url->evaluate()) . '" id="openid"><span></span></form>
    <form title="OpenID (other)" method="post" action="' . escape_html($url->evaluate()) . '" id="openid_manual">
        ' . static_evaluate_tempcode(symbol_tempcode('INSERT_SPAMMER_BLACKHOLE')) . '

        <label for="openid_identifier">Other service</label>:
        <input id="openid_identifier" name="openid_identifier" type="text" size="30" value="" />
        <input type="submit" value="Go" />
    </form>
';
