{$INC,big_tab_sets}

{$REQUIRE_JAVASCRIPT,core_rich_media}
{$REQUIRE_CSS,big_tabs}

<div class="comcode_big_tab_controller" role="tablist" data-tpl-core-rich-media="comcodeBigTabsController" data-tpl-args="{+START,PARAMS_JSON,SWITCH_TIME,PASS_ID,big_tab_sets,TABS}{_*}{+END}">
	{+START,LOOP,TABS}
		<div class="{$?,{$EQ,{_loop_key},0},big_tab_active big_tab_first,big_tab_inactive}" id="{PASS_ID|*}_{$GET%,big_tab_sets}_btgoto_{_loop_var|*}">
			<a aria-controls="{PASS_ID|*}_{$GET%,big_tab_sets}_section_{_loop_var|*}" role="tab" href="#!" onclick="return flip_page('{_loop_var|;*}','{PASS_ID|;*}_{$GET%,big_tab_sets}',a{PASS_ID|*}_{$GET%,big_tab_sets}_big_tab);"><span>{_loop_var}</span></a>
		</div>
	{+END}
</div>
