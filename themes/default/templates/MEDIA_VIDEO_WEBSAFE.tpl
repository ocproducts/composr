{$REQUIRE_JAVASCRIPT,jwplayer}
{$SET,player_id,player-{$RAND}}

{$SET,player_width,{$MIN,950,{WIDTH%}}}
{$SET,player_height,{$MIN,{$MULT,{HEIGHT},{$DIV_FLOAT,950,{WIDTH}}},{HEIGHT%}}}

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

	<meta itemprop="width" content="{$GET*,player_width}" />
	<meta itemprop="height" content="{$GET*,player_height}" />
	{+START,IF_NON_EMPTY,{LENGTH}}
		<meta itemprop="duration" content="T{LENGTH*}S" />
	{+END}
	{+START,IF_NON_EMPTY,{THUMB_URL}}
		<meta itemprop="thumbnailURL" content="{$ENSURE_PROTOCOL_SUITABILITY*,{THUMB_URL}}" />
	{+END}
	<meta itemprop="embedURL" content="{$ENSURE_PROTOCOL_SUITABILITY*,{URL}}" />

	<div class="webstandards-checker-off" id="{$GET%,player_id}"></div>

	{+START,IF_NON_EMPTY,{DESCRIPTION}}
		<figcaption class="associated-details">
			{$PARAGRAPH,{DESCRIPTION}}
		</figcaption>
	{+END}

	{$,Uncomment for a download link \{+START,INCLUDE,MEDIA__DOWNLOAD_LINK\}\{+END\}}
{+END}

<div class="media-video-websafe is-jwplayer" data-tpl="mediaVideoWebsafe" data-tpl-params="{+START,PARAMS_JSON,player_id,player_width,player_height,LENGTH,URL,THUMB_URL,type,flashplayer,inline_stats,RESPONSIVE,AUTOSTART,CLOSED_CAPTIONS_URL}{_*}{+END}" 
	  data-cms-embedded-media="{ width: {$GET%,player_width}, height: {$GET%,player_height}, emits: ['play', 'pause', 'ended'], listens: ['do-play', 'do-pause']  }">
	{+START,IF,{$GET,raw_video}}
		<video {+START,IF_NON_EMPTY,{THUMB_URL}} poster="{$ENSURE_PROTOCOL_SUITABILITY*,{THUMB_URL}}"{+END} width="{$GET*,player_width}" height="{$GET*,player_height}" controls="controls"{+START,IF_PASSED_AND_TRUE,AUTOSTART} autoplay="true"{+END}>
			<source src="{$ENSURE_PROTOCOL_SUITABILITY*,{URL}}" type="{MIME_TYPE*}" />
			{+START,IF_PASSED,CLOSED_CAPTIONS_URL}{+START,IF_NON_EMPTY,{CLOSED_CAPTIONS_URL}}
				<track src="{$ENSURE_PROTOCOL_SUITABILITY*,{CLOSED_CAPTIONS_URL}}" kind="captions" label="{!CLOSED_CAPTIONS}" />
			{+END}{+END}
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
