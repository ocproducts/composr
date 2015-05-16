{$REQUIRE_JAVASCRIPT,dyn_comcode}

<div class="pagination comcode_section_controller">
	<a id="{PASS_ID|*}_has_previous_yes" href="#" onclick="return flip_page(-1,'{PASS_ID|;*}',a{PASS_ID|*}_sections);" class="light first-child">&laquo;&nbsp;{!PREVIOUS}</a>{+START,IF,{$MOBILE}} {+END}<span id="{PASS_ID|*}_has_previous_no" style="display: none" class="light first-child">&laquo;&nbsp;{!PREVIOUS}</span>{+START,LOOP,SECTIONS}<a id="{PASS_ID|*}_goto_{_loop_var|*}" href="#" onclick="return flip_page('{_loop_var|;*}','{PASS_ID|;*}',a{PASS_ID|*}_sections);" title="{_loop_var*}: {!RESULTS_LAUNCHER_JUMP,{_loop_var*},{!PAGE}}" class="results_continue">{_loop_var*}</a>{+START,IF,{$MOBILE}} {+END}<span style="display: none" id="{PASS_ID|*}_isat_{_loop_var|*}" class="results_page_num">{_loop_var*}</span>{+END}<a id="{PASS_ID|*}_has_next_yes" href="#" onclick="return flip_page(1,'{PASS_ID|;*}',a{PASS_ID|*}_sections);" class="light">{!NEXT}&nbsp;&raquo;</a>{+START,IF,{$MOBILE}} {+END}<span id="{PASS_ID|*}_has_next_no" style="display: none" class="light">{!NEXT}&nbsp;&raquo;</span>
</div>

<script>// <![CDATA[
	var a{PASS_ID|}_sections=[];
	add_event_listener_abstract(window,'load',function() {
		{+START,LOOP,SECTIONS}
			a{PASS_ID|}_sections.push('{_loop_var|;}');
		{+END}
		flip_page(0,'{PASS_ID|;}',a{PASS_ID|}_sections);
	});
//]]></script>

