{$REQUIRE_JAVASCRIPT,actionlog}
{+START,SET,tooltip}
	{+START,IF_EMPTY,{RENDERED_DIFF}}<em>{!DIFF_NONE;}</em>{+END}
	{$?,{$LT,{$LENGTH,{RENDERED_DIFF}},5000},<div class="diff">{$REPLACE,\\n,<br />,{RENDERED_DIFF;}}</div>,<em>{!DIFF_TOO_MUCH;}</em>}
{+END}

{+START,IF,{$DESKTOP}}
	<span class="inline-desktop">
		<img data-tpl="revisionsDiffIcon" class="button-icon" data-mouseover-activate-tooltip="['{$GET;^*,tooltip}','500px',null,'auto',true,true]" width="24" height="24" src="{$IMG*,icons/32x32/help}" alt="{!DIFF}" />
	</span>
{+END}
<div class="block-mobile">
	{$GET,tooltip}
</div>
