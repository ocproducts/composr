{+START,SET,media}
	{$SET,player_id,player_{$RAND}}

	{$REQUIRE_JAVASCRIPT,mediaelement-and-player}
	{$REQUIRE_CSS,mediaelementplayer}

	{+START,IF_NON_PASSED_OR_FALSE,WYSIWYG_EDITABLE}
		{+START,IF_EMPTY,{$METADATA,video}}
			{$METADATA,video,{URL}}
			{$METADATA,video:height,{HEIGHT}}
			{$METADATA,video:width,{WIDTH}}
			{$METADATA,video:type,{MIME_TYPE}}
		{+END}
	{+END}

	<audio controls="controls" preload="none" id="{$GET%,player_id}">
		<source type="{MIME_TYPE*}" src="{URL*}" />
		<object width="{WIDTH*}" height="{HEIGHT*}" type="application/x-shockwave-flash" data="{$BASE_URL*}/data_custom/mediaelement/flashmediaelement.swf">
			<param name="movie" value="{$BASE_URL*}/data_custom/mediaelement/flashmediaelement.swf" />
			<param name="flashvars" value="controls=true&amp;file={URL&*}" />

			<img src="{THUMB_URL*}" width="{WIDTH*}" height="{HEIGHT*}" title="No audio playback capabilities" />
		</object>
	</audio>

	<script>// <![CDATA[
		add_event_listener_abstract(window,'load',function() {
			var player=new MediaElementPlayer('#{$GET%,player_id}',{
				{$,Scale to a maximum width because we can always maximise - for object/embed players we can use max-width for this}
				{+START,IF_NON_EMPTY,{WIDTH}}
					audioWidth: {$MIN,1000,{WIDTH%}},
				{+END}
				{+START,IF_NON_EMPTY,{HEIGHT}}
					audioHeight: {$MIN,{$MULT,{HEIGHT},{$DIV_FLOAT,1000,{WIDTH}}},{HEIGHT%}},
				{+END}

				enableKeyboard: true
			});

			{+START,IF,{$NOT,{$INLINE_STATS}}}
				player.addEventListener('play',function() { ga_track(null,'{!AUDIO;/}','{URL;/}'); });
			{+END}
			if (document.getElementById('next_slide'))
			{
				player.addEventListener('canplay',function() { stop_slideshow_timer(); player.play(); });
				player.addEventListener('ended',function() { player_stopped(); });
			}
		});
	//]]></script>

	{+START,IF_NON_EMPTY,{DESCRIPTION}}
		<figcaption class="associated_details">
			{$PARAGRAPH,{DESCRIPTION}}
		</figcaption>
	{+END}

	{$,Uncomment for a download link \{+START,INCLUDE,MEDIA__DOWNLOAD_LINK\}\{+END\}}
{+END}
{+START,IF_PASSED_AND_TRUE,FRAMED}
	<figure>
		{$GET,media}
	</figure>
{+END}
{+START,IF_NON_PASSED_OR_FALSE,FRAMED}
	{$GET,media}
{+END}
