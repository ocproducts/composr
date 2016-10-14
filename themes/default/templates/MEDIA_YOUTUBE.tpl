{$SET,player_id,player_{$RAND}}

<div id="{$GET*,player_id}"></div>

{+START,IF_NON_EMPTY,{DESCRIPTION}}
	<figcaption class="associated_details">
		{$PARAGRAPH,{DESCRIPTION}}
	</figcaption>
{+END}

<script>// <![CDATA[
	var slideshow_mode=document.getElementById('next_slide');

	{$,Tie into callback event to see when finished, for our slideshows}
	{$,API: https://developers.google.com/youtube/iframe_api_reference}
	var {$GET%,player_id};
	var youtube_callback_{$GET%,player_id}=function()
	{
		{$GET%,player_id}=new YT.Player('{$GET%,player_id}', {
			width: '{WIDTH;/}',
			height: '{HEIGHT;/}',
			videoId: '{REMOTE_ID;/}',
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

	if (typeof window.done_youtube_player_init=='undefined')
	{
		var tag=document.createElement('script');
		tag.src="https://www.youtube.com/iframe_api";
		var first_script_tag=document.getElementsByTagName('script')[0];
		first_script_tag.parentNode.insertBefore(tag,first_script_tag);
		window.done_youtube_player_init=true;

		window.onYouTubeIframeAPIReady=youtube_callback_{$GET%,player_id};
	} else
	{
		add_event_listener_abstract(window,'real_load',function() {
			youtube_callback_{$GET%,player_id}();
		});
	}
//]]></script>
