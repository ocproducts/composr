{$SET,player_id,player_{$RAND}}

<div class="youtube_player"><div id="{$GET*,player_id}" data-tpl="mediaYoutube" data-tpl-params="{+START,PARAMS_JSON,WIDTH,HEIGHT,REMOTE_ID}{_*}{+END}"></div></div>

{+START,IF_NON_EMPTY,{DESCRIPTION}}
	<figcaption class="associated_details">
		{$PARAGRAPH,{DESCRIPTION}}
	</figcaption>
{+END}
