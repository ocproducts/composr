<span class="credits_bar">
	{+START,IF,{$NOT,{$IS_GUEST}}}
		<span class="gb_credits_available">{CREDITS_MSG*}</span>{NO_CREDITS_LINK*}{+START,IF,{$NEQ,{TICKETS_OPEN},0}}{TICKETS_OPEN_MSG}{+END}
	{+END}
	{+START,IF_NON_EMPTY,{WHATS_THIS}}
		<span class="gb_help">{WHATS_THIS*}</span>
	{+END}
</span>
