<div class="block_main_mantis_tracker">
	<iframe title="{!TRACKER}"{$?,{$BROWSER_MATCHES,ie}, frameBorder="0"} name="{FRAME_NAME%}" id="{FRAME_NAME%}" class="expandable_iframe" scrolling="no" src="{$FIND_SCRIPT*,tracker}{PARAMS*}">{!TRACKER}</iframe>
</div>

<script>// <![CDATA[
	window.setInterval(function() {
		if ((typeof window.frames['{FRAME_NAME%}']!='undefined') && (typeof window.frames['{FRAME_NAME%}'].trigger_resize!='undefined'))
		{
			resize_frame('{FRAME_NAME%}');
		}
	}, 1000);
//]]></script>
