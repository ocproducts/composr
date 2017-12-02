{+START,SET,media}
	{$SET,player_id,player_{$RAND}}

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

	<audio controls="controls" preload="none" id="{$GET%,player_id}" data-require-javascript="['mediaelement-and-player', 'core_rich_media']" data-tpl="mediaAudioWebsafe">
		<source type="{MIME_TYPE*}" src="{$ENSURE_PROTOCOL_SUITABILITY*,{URL}}" />
		<object width="{WIDTH*}" height="{HEIGHT*}" type="application/x-shockwave-flash" data="{$BASE_URL*}/data_custom/mediaelement/flashmediaelement.swf">
			<param name="movie" value="{$BASE_URL*}/data_custom/mediaelement/flashmediaelement.swf" />
			<param name="flashvars" value="controls=true&amp;file={URL&*}" />

			<img src="{THUMB_URL*}" width="{WIDTH*}" height="{HEIGHT*}" alt="No audio playback capabilities" title="No audio playback capabilities" />
		</object>
	</audio>

	{+START,IF_NON_EMPTY,{DESCRIPTION}}
		<figcaption class="associated-details">
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
