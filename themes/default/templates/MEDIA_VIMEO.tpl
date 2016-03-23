{$SET,player_id,player_{$RAND}}

<div class="webstandards_checker_off">
	<iframe id="{$GET*,player_id}" src="https://player.vimeo.com/video/{REMOTE_ID*}?api=1"{+START,IF,{$_GET,slideshow}} autoplay="1"{+END} width="{WIDTH*}" height="{HEIGHT*}" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>
</div>

{+START,IF_NON_EMPTY,{DESCRIPTION}}
	<figcaption class="associated_details">
		{$PARAGRAPH,{DESCRIPTION}}
	</figcaption>
{+END}

{$,Tie into callback event to see when finished, for our slideshows}
<script>// <![CDATA[
	add_event_listener_abstract(window,'real_load',function() {
		if (document.getElementById('next_slide'))
		{
			stop_slideshow_timer();
			window.setTimeout(function() {
				if (typeof window.addEventListener!='undefined')
				{
					window.addEventListener('message',player_stopped,false);
				} else
				{
					window.attachEvent('onmessage',player_stopped,false);
				}

				var player=document.getElementById('{$GET*,player_id}');
				player.contentWindow.postMessage(JSON.stringify({ method: 'addEventListener', value: 'finish' }),'https://player.vimeo.com/video/{REMOTE_ID;/}');
			}, 1000);
		}
	});
//]]></script>
