<li>
	{+START,SET,tooltip}
		{+START,IF_EMPTY,{RENDERED_DIFF}}<em>{!DIFF_NONE;}</em>{+END}
		{$?,{$LT,{$LENGTH,{RENDERED_DIFF}},5000},<div class="diff">{$REPLACE,\\n,<br />,{RENDERED_DIFF;}}</div>,<em>{!DIFF_TOO_MUCH;}</em>}
	{+END}

	{+START,IF_PASSED,DATE}{+START,IF_PASSED,EDITOR}
		{+START,IF_NON_PASSED_OR_FALSE,REFERENCE_POINT_EXACT}
			{!REVISION_TAG_LINE,{EDITOR*},{DATE*},{RESTORE_URL*},{SIZE*},{$STRIP_TAGS,{DATE*}}}
		{+END}
		{+START,IF_PASSED_AND_TRUE,REFERENCE_POINT_EXACT}
			{!REVISION_TAG_LINE_2,{EDITOR*},{DATE*},{RESTORE_URL*},{SIZE*},{$STRIP_TAGS,{DATE*}}}
		{+END}
	{+END}{+END}
	{+START,IF_NON_PASSED,DATE}{+START,IF_NON_PASSED,EDITOR}
		{!REVISION_TAG_LINE_3,{RESTORE_URL*},{SIZE*}}
	{+END}{+END}

	<img class="button_icon" onmouseover="if (typeof window.activate_tooltip!='undefined') activate_tooltip(this,event,'{$GET;^*,tooltip}','500px',null,'auto',true,true);" onmousemove="if (typeof window.activate_tooltip!='undefined') reposition_tooltip(this,event,true);" src="{$IMG*,icons/16x16/help}" srcset="{$IMG*,icons/32x32/help} 2x" alt="{!DIFF}" />
</li>

