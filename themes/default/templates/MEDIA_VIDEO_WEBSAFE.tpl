{$REQUIRE_JAVASCRIPT,jwplayer}
{$SET,player_id,player_{$RAND}}

{$,Scale to a maximum width because we can always maximise - for object/embed players we can use max-width for this}

{$SET,player_width,}
{+START,IF_NON_EMPTY,{WIDTH}}
	{$SET,player_width,{$MIN,1000,{WIDTH%}}},
{+END}
{$SET,player_height,}
{+START,IF_NON_EMPTY,{HEIGHT}}
	{$SET,player_height,{$MIN,{$MULT,{HEIGHT},{$DIV_FLOAT,1000,{WIDTH}}},{HEIGHT%}}},
{+END}

{$SET,duration,}
{+START,IF_NON_EMPTY,{LENGTH}}
	{$SET,duration,{LENGTH}}
{+END}
{$SET,type,{$PREG_REPLACE,.*\.,,{$LCASE,{FILENAME}}}}
{$SET,flashplayer,{$BASE_URL}/data/jwplayer.flash.swf{+START,IF,{$NOT,{$BROWSER_MATCHES,bot}}}?rand={$RAND}{+END}}
{$SET,inline_stats,{$INLINE_STATS}}

{+START,SET,media}
	{+START,IF_NON_PASSED_OR_FALSE,WYSIWYG_EDITABLE}
		{+START,IF_EMPTY,{$METADATA,video}}
			{$METADATA,video,{URL}}
			{$METADATA,video:height,{HEIGHT}}
			{$METADATA,video:width,{WIDTH}}
			{$METADATA,video:type,{MIME_TYPE}}
		{+END}
	{+END}

	<meta itemprop="width" content="{$MIN*,950,{WIDTH}}" />
	<meta itemprop="height" content="{$MIN*,{$MULT,{HEIGHT},{$DIV_FLOAT,950,{WIDTH}}},{HEIGHT}}" />
	{+START,IF_NON_EMPTY,{LENGTH}}
		<meta itemprop="duration" content="T{LENGTH*}S" />
	{+END}
	<meta itemprop="thumbnailURL" content="{THUMB_URL*}" />
	<meta itemprop="embedURL" content="{URL*}" />

	<div class="webstandards_checker_off" id="{$GET%,player_id}"></div>
<<<<<<< HEAD
=======

	{$,API: http://www.longtailvideo.com/support/jw-player/jw-player-for-flash-v5/12540/javascript-api-reference}

	<script>// <![CDATA[
		{$,Carefully tuned to avoid this problem: http://www.longtailvideo.com/support/forums/jw-player/setup-issues-and-embedding/8439/sound-but-no-video}
		add_event_listener_abstract(window,'load',function() {
			jwplayer('{$GET%,player_id}').setup({
				{$,Scale to a maximum width because we can always maximise - for object/embed players we can use max-width for this}
				{+START,IF_NON_EMPTY,{WIDTH}}
					width: {$MIN%,950,{WIDTH}},
				{+END}
				{+START,IF_NON_EMPTY,{HEIGHT}}
					height: {$MIN%,{$MULT,{HEIGHT},{$DIV_FLOAT,950,{WIDTH}}},{HEIGHT}},
				{+END}

				autostart: false,
				{+START,IF_NON_EMPTY,{LENGTH}}
					duration: {LENGTH%},
				{+END}
				file: '{URL;/}',
				type: '{$PREG_REPLACE*,.*\.,,{$LCASE,{FILENAME}}}',
				image: '{THUMB_URL;/}',
				flashplayer: '{$BASE_URL;/}/data/jwplayer.flash.swf{+START,IF,{$NOT,{$BROWSER_MATCHES,bot}}}?rand={$RAND;/}{+END}',
				events: {
					{+START,IF,{$NOT,{$INLINE_STATS}}}onPlay: function() { ga_track(null,'{!VIDEO;/}','{URL;/}'); },{+END}
					onComplete: function() { if (document.getElementById('next_slide')) player_stopped(); },
					onReady: function() { if (document.getElementById('next_slide')) { stop_slideshow_timer(); jwplayer('{$GET%,player_id}').play(true); } }
				}
			});
		});
	//]]></script>

>>>>>>> master
	{+START,IF_NON_EMPTY,{DESCRIPTION}}
		<figcaption class="associated_details">
			{$PARAGRAPH,{DESCRIPTION}}
		</figcaption>
	{+END}

	{$,Uncomment for a download link \{+START,INCLUDE,MEDIA__DOWNLOAD_LINK\}\{+END\}}
{+END}

<div data-tpl="mediaAudioWebsafe" data-tpl-params="{+START,PARAMS_JSON,player_id,player_width,player_height,LENGTH,URL,THUMB_URL,type,flashplayer,inline_stats}{_*}{+END}">
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
</div>