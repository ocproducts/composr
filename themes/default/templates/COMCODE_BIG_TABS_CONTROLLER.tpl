{$INC,big_tab_sets}

{$REQUIRE_JAVASCRIPT,dyn_comcode}
{$REQUIRE_CSS,big_tabs}

<div class="comcode_big_tab_controller" role="tablist">
	{+START,LOOP,TABS}
		<div class="{$?,{$EQ,{_loop_key},0},big_tab_active big_tab_first,big_tab_inactive}" id="{PASS_ID|*}_{$GET%,big_tab_sets}_btgoto_{_loop_var|*}">
			<a aria-controls="{PASS_ID|*}_{$GET%,big_tab_sets}_section_{_loop_var|*}" role="tab" href="#" onclick="return flip_page('{_loop_var|;*}','{PASS_ID|;*}_{$GET%,big_tab_sets}',a{PASS_ID|*}_{$GET%,big_tab_sets}_big_tab);"><span>{_loop_var}</span></a>
		</div>
	{+END}
</div>

<script>// <![CDATA[
	{+START,IF_PASSED,SWITCH_TIME}
		function move_between_big_tabs_{PASS_ID|}_{$GET%,big_tab_sets}()
		{
			var next_page=0,i,x;
			for (i=0;i<a{PASS_ID|}_{$GET%,big_tab_sets}_big_tab.length;i++)
			{
				x=document.getElementById('{PASS_ID|*}_{$GET%,big_tab_sets}_section_'+a{PASS_ID|}_{$GET%,big_tab_sets}_big_tab[i]);
				if ((x.style.display=='block') && (x.style.position!='absolute'))
				{
					next_page=i+1;
				}
			}
			if (next_page==a{PASS_ID|}_{$GET%,big_tab_sets}_big_tab.length) next_page=0;
			flip_page(a{PASS_ID|}_{$GET%,big_tab_sets}_big_tab[next_page],'{PASS_ID|;}_{$GET%,big_tab_sets}',a{PASS_ID|}_{$GET%,big_tab_sets}_big_tab);
		}
	{+END}

	add_event_listener_abstract(window,'load',function() {
		big_tabs_init();

		window.a{PASS_ID|}_{$GET%,big_tab_sets}_big_tab=[];
		{+START,LOOP,TABS}
			a{PASS_ID|}_{$GET%,big_tab_sets}_big_tab.push('{_loop_var|;}');
		{+END}
		window.big_tabs_auto_cycler_{PASS_ID|}_{$GET%,big_tab_sets}=null;
		{+START,IF_PASSED,SWITCH_TIME}
			window.big_tabs_switch_time_{PASS_ID|}_{$GET%,big_tab_sets}={SWITCH_TIME%};
			flip_page(0,'{PASS_ID|;}_{$GET%,big_tab_sets}',a{PASS_ID|}_{$GET%,big_tab_sets}_big_tab);
		{+END}
	});
//]]></script>
