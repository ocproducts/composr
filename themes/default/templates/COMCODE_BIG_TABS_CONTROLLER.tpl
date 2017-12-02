{$INC,big_tab_sets}

{$REQUIRE_JAVASCRIPT,core_rich_media}
{$REQUIRE_CSS,big_tabs}

<div class="comcode-big-tab-controller" role="tablist" data-view="ComcodeBigTabsController" data-view-params="{+START,PARAMS_JSON,SWITCH_TIME,PASS_ID,big_tab_sets,TABS}{_*}{+END}">
	{+START,LOOP,TABS}
		<div class="{$?,{$EQ,{_loop_key},0},big-tab-active big-tab-first,big-tab-inactive}" id="{PASS_ID|*}_{$GET%,big_tab_sets}_btgoto_{_loop_var|*}">
			<a aria-controls="{PASS_ID|*}_{$GET%,big_tab_sets}_section_{_loop_var|*}" role="tab" href="#!" class="js-onclick-flip-page" data-vw-flip-to="{_loop_var|*}"><span>{_loop_var}</span></a>
		</div>
	{+END}
</div>
