{+START,IF,{$TAPATALK}}
	<div>
		<em>{!FROM} {TITLE*}{+START,IF_PASSED,DATE}, {DATE*}{+END}</em>
	</div>
{+END}

{+START,IF,{$NOT,{$TAPATALK}}}
	<div class="comcode_snapback associated_link">
		{!FROM} &ldquo;<a href="{$?*,{$AND,{$CNS},{$EQ,{$BASE_URL},{$FORUM_BASE_URL}}},{$PAGE_LINK,_SEARCH:topicview:findpost:{POST_ID}:threaded={$_GET,threaded,<null>}},{URL}}">{TITLE*}</a>&rdquo;{+START,IF_PASSED,DATE}, {DATE*}{+END}
	</div>
{+END}
