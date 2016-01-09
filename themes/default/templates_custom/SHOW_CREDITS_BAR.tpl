<span class="credits_bar">
	{+START,IF,{$NOT,{$IS_GUEST}}}
		<span class="gb_credits_available">{CREDITS_AVAILABLE*}</span>{NO_CREDITS_LINK*}
	{+END}
	{+START,IF_NON_EMPTY,{WHATS_THIS}}
		<span class="gb_help">{WHATS_THIS*}</span>
	{+END}
</span>
