{$SET,player_id,player_{$RAND}}

<div id="{$GET*,player_id}"></div>

{+START,IF_NON_EMPTY,{DESCRIPTION}}
	<figcaption class="associated_details">
		{$PARAGRAPH,{DESCRIPTION}}
	</figcaption>
{+END}

<script>
	if (typeof window.done_youtube_player_init=='undefined')
	{
		var tag=document.createElement('script');
		tag.src="https://www.youtube.com/iframe_api";
		var first_script_tag=document.getElementsByTagName('script')[0];
		first_script_tag.parentNode.insertBefore(tag,first_script_tag);
		window.done_youtube_player_init=true;
	}

<<<<<<< HEAD
	$(function() {
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
=======
	var slideshow_mode=document.getElementById('next_slide');

	{$,Tie into callback event to see when finished, for our slideshows}
	{$,API: https://developers.google.com/youtube/iframe_api_reference}
	var {$GET%,player_id};
	function onYouTubeIframeAPIReady()
	{
		{$GET%,player_id}=new YT.Player('{$GET%,player_id}', {
			width: '{WIDTH;}',
			height: '{HEIGHT;}',
			videoId: '{REMOTE_ID;}',
			events: {
				'onReady': function() {
					if (slideshow_mode) {
						{$GET%,player_id}.playVideo();
					}
				},
				'onStateChange': function(newState) {
					if (slideshow_mode) {
						if (newState==0) player_stopped();
					}
				}
			}
		});
	}
</script>
>>>>>>> master
