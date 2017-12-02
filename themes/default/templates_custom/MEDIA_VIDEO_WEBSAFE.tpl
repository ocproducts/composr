{$REQUIRE_JAVASCRIPT,core_rich_media}

{+START,SET,media}
	{$SET,player_id,player_{$RAND}}

	{$REQUIRE_JAVASCRIPT,jquery}
	{$REQUIRE_JAVASCRIPT,mediaelement-and-player}
	{$REQUIRE_JAVASCRIPT,core_rich_media}
	{$REQUIRE_CSS,mediaelementplayer}

	{+START,IF_NON_PASSED_OR_FALSE,WYSIWYG_EDITABLE}
		{+START,IF_EMPTY,{$METADATA,video}}
			{$METADATA,video,{URL}}
			{$METADATA,video:height,{HEIGHT}}
			{$METADATA,video:width,{WIDTH}}
			{$METADATA,video:type,{MIME_TYPE}}
		{+END}
	{+END}

	<div class="responsive_video">
		<video width="{$MIN*,950,{WIDTH}}" height="{$MIN*,{$MULT,{HEIGHT},{$DIV_FLOAT,950,{WIDTH}}},{HEIGHT}}" poster="{THUMB_URL*}" controls="controls" preload="none" id="{$GET%,player_id}" data-require-javascript="['mediaelement-and-player','core_rich_media']" data-tpl="mediaVideoWebsafe" data-tpl-params="{+START,PARAMS_JSON,player_id,WIDTH,HEIGHT,URL}{_*}{+END}">
			<source type="{MIME_TYPE*}" src="{$ENSURE_PROTOCOL_SUITABILITY*,{URL}}" />
			<object width="{$MIN*,950,{WIDTH}}" height="{$MIN*,{$MULT,{HEIGHT},{$DIV_FLOAT,950,{WIDTH}}},{HEIGHT}}" type="application/x-shockwave-flash" data="{$BASE_URL*}/data_custom/mediaelement/flashmediaelement.swf">
				<param name="movie" value="{$BASE_URL*}/data_custom/mediaelement/flashmediaelement.swf" />
				<param name="flashvars" value="controls=true&amp;file={URL&*}" />

				<img src="{THUMB_URL*}" width="{$MIN*,950,{WIDTH}}" height="{$MIN*,{$MULT,{HEIGHT},{$DIV_FLOAT,950,{WIDTH}}},{HEIGHT}}" alt="No video playback capabilities" title="No video playback capabilities" />
			</object>
		</video>
	</div>

	{+START,IF_NON_EMPTY,{DESCRIPTION}}
		<figcaption class="associated-details">
			{$PARAGRAPH,{DESCRIPTION}}
		</figcaption>
	{+END}

	{$,Uncomment for a download link \{+START,INCLUDE,MEDIA__DOWNLOAD_LINK\}\{+END\}}
{+END}
{+START,IF,{$GET,raw_video}}
	<video {+START,IF_NON_EMPTY,{THUMB_URL}} poster="{THUMB_URL*}"{+END} width="{$MIN*,950,{WIDTH}}" height="{$MIN*,{$MULT,{HEIGHT},{$DIV_FLOAT,950,{WIDTH}}},{HEIGHT}}" controls="controls">
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
