{+START,SET,tooltip}
	{+START,IF_EMPTY,{RENDERED_DIFF}}<em>{!DIFF_NONE;}</em>{+END}
	{$?,{$LT,{$LENGTH,{RENDERED_DIFF}},5000},<div class="diff">{$REPLACE,\\n,<br />,{RENDERED_DIFF;}}</div>,<em>{!DIFF_TOO_MUCH;}</em>}
{+END}

<img class="button_icon" data-mouseover-activate-tooltip="['{$GET;^*,tooltip}','500px',null,'auto',true,true]" onmousemove="reposition_tooltip(this,event,true);" src="{$IMG*,icons/16x16/help}" srcset="{$IMG*,icons/32x32/help} 2x" alt="{!DIFF}" />
