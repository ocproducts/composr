{+START,IF,{$TAPATALK}}
	<div>
		<em>{!FROM} {TITLE*}{+START,IF_PASSED,DATE}, {DATE*}{+END}</em>
	</div>
{+END}

{+START,IF,{$NOT,{$TAPATALK}}}
	<div class="comcode_snapback associated_link">
		{!FROM} &ldquo;<a href="{$?*,{$AND,{$OCF},{$EQ,{$BASE_URL},{$BOARD_PREFIX}}},{$PAGE_LINK,_SEARCH:topicview:findpost:{POST_ID}:threaded={$_GET,threaded,<null>}},{URL}}">{TITLE*}</a>&rdquo;{+START,IF_PASSED,DATE}, {DATE*}{+END}
	</div>
{+END}
