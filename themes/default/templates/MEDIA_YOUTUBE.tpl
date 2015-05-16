{$SET,player_id,player_{$RAND}}

<div class="webstandards_checker_off">
	<embed id="{$GET,player_id}" type="application/x-shockwave-flash" width="{WIDTH*}" height="{HEIGHT*}"
		src="http://www.youtube.com/v/{REMOTE_ID*}?enablejsapi=1"
		data="http://www.youtube.com/v/{REMOTE_ID*}?enablejsapi=1"
		wmode="transparent"
		allowscriptaccess="always" allowfullscreen="true"
	></embed>
</div>

{+START,IF_NON_EMPTY,{DESCRIPTION}}
	<figcaption class="associated_details">
		{$PARAGRAPH,{DESCRIPTION}}
	</figcaption>
{+END}

{$,Tie into callback event to see when finished, for our slideshows}
{$,API: http://code.google.com/apis/youtube/js_api_reference.html#Events}
<script>// <![CDATA[
	function youtubeStateChanged(newState)
	{
		if (newState==0) player_stopped();
	}

	add_event_listener_abstract(window,'real_load',function() {
		if (document.getElementById('next_slide'))
		{
			stop_slideshow_timer();
			window.setTimeout(function() {
				document.getElementById('{$GET;,player_id}').addEventListener('onStateChange','youtubeStateChanged');
				document.getElementById('{$GET;,player_id}').playVideo();
			}, 1000);
		}
	});
//]]></script>
