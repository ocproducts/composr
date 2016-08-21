{$SET,player_id,player_{$RAND}}

<div id="{$GET*,player_id}" data-tpl-core-rich-media="mediaYoutube" data-tpl-args="{+START,PARAMS_JSON,WIDTH,HEIGHT,REMOTE_ID}{_*}{+END}"></div>

{+START,IF_NON_EMPTY,{DESCRIPTION}}
	<figcaption class="associated_details">
		{$PARAGRAPH,{DESCRIPTION}}
	</figcaption>
{+END}