{+START,IF,{$TAPATALK}}
	<div>
		<em>{!FROM} {TITLE*}{+START,IF_PASSED,DATE}, {DATE*}{+END}</em>
	</div>
{+END}

{+START,IF,{$NOT,{$TAPATALK}}}
	<div class="comcode_snapback associated_link">
		{!FROM} &ldquo;<a href="{URL*}">{TITLE*}</a>&rdquo;{+START,IF_PASSED,DATE}, {DATE*}{+END}
	</div>
{+END}
