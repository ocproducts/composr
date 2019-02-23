{$SET,type,{$PREG_REPLACE*,.*\.,,{$LCASE,{FILENAME}}}}
{$SET,flashplayer,{$BASE_URL}/data/jwplayer.flash.swf{+START,IF,{$NOT,{$BROWSER_MATCHES,bot}}}?rand={$RAND}{+END}}
{$SET,inline_stats,{$INLINE_STATS}}
{+START,SET,media}
	{$SET,player_id,player-{$RAND}}

	{$REQUIRE_JAVASCRIPT,jwplayer}

	{+START,IF_NON_PASSED_OR_FALSE,WYSIWYG_EDITABLE}
		{+START,IF_EMPTY,{$METADATA,video}}
			{$METADATA,video,{URL}}
			{$METADATA,video:height,{HEIGHT}}
			{$METADATA,video:width,{WIDTH}}
			{$METADATA,video:type,{MIME_TYPE}}
		{+END}
	{+END}

	<meta itemprop="width" content="{WIDTH*}" />
	<meta itemprop="height" content="{HEIGHT*}" />
	{+START,IF_NON_EMPTY,{LENGTH}}
		<meta itemprop="duration" content="T{LENGTH*}S" />
	{+END}
	{+START,IF_NON_EMPTY,{THUMB_URL}}
		<meta itemprop="thumbnailURL" content="{THUMB_URL*}" />
	{+END}
	<meta itemprop="embedURL" content="{URL*}" />

	<div class="webstandards-checker-off" id="{$GET%,player_id}"></div>

	{+START,IF_NON_EMPTY,{DESCRIPTION}}
		<figcaption class="associated-details">
			{$PARAGRAPH,{DESCRIPTION}}
		</figcaption>
	{+END}

	{$,Uncomment for a download link \{+START,INCLUDE,MEDIA__DOWNLOAD_LINK\}\{+END\}}
{+END}

<div class="media-audio-websafe" data-tpl="mediaAudioWebsafe" data-tpl-params="{+START,PARAMS_JSON,player_id,WIDTH,HEIGHT,LENGTH,URL,THUMB_URL,type,flashplayer,inline_stats,AUTOSTART,CLOSED_CAPTIONS_URL}{_*}{+END}" 
	  data-cms-embedded-media="{ width: {WIDTH%}, height: {HEIGHT%}, emits: ['play', 'pause', 'ended'], listens: ['do-play', 'do-pause']  }">
	{+START,IF_PASSED_AND_TRUE,FRAMED}
		<figure>
			{$GET,media}
		</figure>
	{+END}
	{+START,IF_NON_PASSED_OR_FALSE,FRAMED}
		{$GET,media}
	{+END}
</div>
