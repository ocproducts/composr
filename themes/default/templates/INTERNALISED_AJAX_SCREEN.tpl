{$SET,wrapper_id,ajax_block_wrapper_{$RAND%}}
<div id="{$GET*,wrapper_id}">
	{SCREEN_CONTENT}

	{$REQUIRE_JAVASCRIPT,ajax}
	{$REQUIRE_JAVASCRIPT,checking}

	<script>// <![CDATA[
		add_event_listener_abstract(window,'load',function() {
			internalise_ajax_block_wrapper_links('{URL;/}',document.getElementById('{$GET;,wrapper_id}'),['.*'],{ },false,true);
		});
	//]]></script>
</div>

{+START,IF_PASSED,CHANGE_DETECTION_URL}{+START,IF_NON_EMPTY,{CHANGE_DETECTION_URL}}
	<script>
	// <![CDATA[
		{+START,IF_NON_EMPTY,{REFRESH_TIME}}
			window.detect_interval=window.setInterval(
				function() {
					{+START,IF_PASSED,CHANGE_DETECTION_URL}
						if (typeof window.detect_change!='undefined')
						{
							detect_change('{CHANGE_DETECTION_URL;/}','{REFRESH_IF_CHANGED;/}',function() {
								if ((!document.getElementById('post')) || (document.getElementById('post').value==''))
								{
									call_block('{URL;/}','',document.getElementById('{$GET;,wrapper_id}'),false,null,true,null,true);
								}
							});
						}
					{+END}
					{+START,IF_NON_PASSED,CHANGE_DETECTION_URL}
						call_block('{URL;/}','',document.getElementById('{$GET;,wrapper_id}'),false,null,true,null,true);
					{+END}
				},
				{REFRESH_TIME%}*1000);
		{+END}
	//]]></script>
{+END}{+END}

