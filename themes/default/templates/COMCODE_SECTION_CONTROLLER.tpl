{$REQUIRE_JAVASCRIPT,core_rich_media}

<div class="pagination comcode-section-controller" data-view="ComcodeSectionController" data-view-params="{+START,PARAMS_JSON,PASS_ID,SECTIONS}{_*}{+END}">
	<a id="{PASS_ID|*}_has_previous_yes" href="#!" class="light first-child js-click-flip-page" data-vw-flip-to="-1">&laquo;&nbsp;{!PREVIOUS}</a>

	<span id="{PASS_ID|*}_has_previous_no" style="display: none" class="light first-child">&laquo;&nbsp;{!PREVIOUS}</span>

	{+START,LOOP,SECTIONS}
		<a id="{PASS_ID|*}_goto_{_loop_var|*}" href="#!" title="{_loop_var*}: {!RESULTS_LAUNCHER_JUMP,{_loop_var*},{!PAGE}}" class="results-continue js-click-flip-page" data-vw-flip-to="{_loop_var|*}">{_loop_var*}</a>
		<span style="display: none" id="{PASS_ID|*}_isat_{_loop_var|*}" class="results-page-num">{_loop_var*}</span>
	{+END}

	<a id="{PASS_ID|*}_has_next_yes" href="#!" class="light js-click-flip-page" data-vw-flip-to="1">{!NEXT}&nbsp;&raquo;</a>

	<span id="{PASS_ID|*}_has_next_no" style="display: none" class="light">{!NEXT}&nbsp;&raquo;</span>
</div>
