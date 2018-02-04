{$SET,player_id,player-{$RAND}}

<div class="youtube-player"><div id="{$GET*,player_id}" data-tpl="mediaYoutube" data-tpl-params="{+START,PARAMS_JSON,WIDTH,HEIGHT,REMOTE_ID}{_*}{+END}"></div></div>

{+START,IF_NON_EMPTY,{DESCRIPTION}}
	<figcaption class="associated-details">
		{$PARAGRAPH,{DESCRIPTION}}
	</figcaption>
{+END}
