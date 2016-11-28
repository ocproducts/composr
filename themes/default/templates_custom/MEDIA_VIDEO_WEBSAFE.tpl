{+START,SET,media}
	{$SET,player_id,player_{$RAND}}

	{$REQUIRE_JAVASCRIPT,jquery}
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

	<video width="{$MIN*,950,{WIDTH}}" height="{$MIN*,{$MULT,{HEIGHT},{$DIV_FLOAT,950,{WIDTH}}},{HEIGHT}}" poster="{THUMB_URL*}" controls="controls" preload="none" id="{$GET%,player_id}">
		<source type="{MIME_TYPE*}" src="{URL*}" />
		<object width="{$MIN*,950,{WIDTH}}" height="{$MIN*,{$MULT,{HEIGHT},{$DIV_FLOAT,950,{WIDTH}}},{HEIGHT}}" type="application/x-shockwave-flash" data="{$BASE_URL*}/data_custom/mediaelement/flashmediaelement.swf">
			<param name="movie" value="{$BASE_URL*}/data_custom/mediaelement/flashmediaelement.swf" />
			<param name="flashvars" value="controls=true&amp;file={URL&*}" />

			<img src="{THUMB_URL*}" width="{$MIN*,950,{WIDTH}}" height="{$MIN*,{$MULT,{HEIGHT},{$DIV_FLOAT,950,{WIDTH}}},{HEIGHT}}" alt="No video playback capabilities" title="No video playback capabilities" />
		</object>
	</video>

	<div class="webstandards_checker_off"></div>

	<script>// <![CDATA[
		add_event_listener_abstract(window,'load',function() {
			var player=new MediaElementPlayer('#{$GET%,player_id}',{
				{$,Scale to a maximum width because we can always maximise - for object/embed players we can use max-width for this}
				{+START,IF_NON_EMPTY,{WIDTH}}
					videoWidth: {$MIN%,950,{WIDTH}},
				{+END}
				{+START,IF_NON_EMPTY,{HEIGHT}}
					videoHeight: {$MIN%,{$MULT,{HEIGHT},{$DIV_FLOAT,950,{WIDTH}}},{HEIGHT}},
				{+END}

				enableKeyboard: true,

				success: function(media) {
					{+START,IF,{$NOT,{$INLINE_STATS}}}
						media.addEventListener('play',function() { ga_track(null,'{!VIDEO;/}','{URL;/}'); });
					{+END}
					if (document.getElementById('next_slide'))
					{
						media.addEventListener('canplay',function() { stop_slideshow_timer(); player.play(); });
						media.addEventListener('ended',function() { player_stopped(); });
					}
				}
			});
		});
	//]]></script>

	{+START,IF_NON_EMPTY,{DESCRIPTION}}
		<figcaption class="associated_details">
			{$PARAGRAPH,{DESCRIPTION}}
		</figcaption>
	{+END}

	{$,Uncomment for a download link \{+START,INCLUDE,MEDIA__DOWNLOAD_LINK\}\{+END\}}
{+END}
{+START,IF,{$GET,raw_video}}
	<video{+START,IF_NON_EMPTY,{THUMB_URL}} poster="{THUMB_URL*}"{+END} width="{$MIN*,950,{WIDTH}}" height="{$MIN*,{$MULT,{HEIGHT},{$DIV_FLOAT,950,{WIDTH}}},{HEIGHT}}" controls="controls">
		<source src="{$ENSURE_PROTOCOL_SUITABILITY*,{URL}}" type="{MIME_TYPE*}" />
		<span>{DESCRIPTION}</span>
	</video>
{+END}
{+START,IF,{$NOT,{$GET,raw_video}}}
	{+START,IF_PASSED_AND_TRUE,FRAMED}
		<figure>
			{$GET,media}
		</figure>
	{+END}
	{+START,IF_NON_PASSED_OR_FALSE,FRAMED}
		{$GET,media}
	{+END}
{+END}
