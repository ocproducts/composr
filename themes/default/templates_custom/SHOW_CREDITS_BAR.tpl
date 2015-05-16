<div class="gold_bar">
	{+START,IF,{$IS_GUEST}}
		<div class="gb_help">{WHATS_THIS}</div>
		<div class="gb_not_logged_in">{GUEST_MSG}</div>
	{+END}
	{+START,IF,{$NOT,{$IS_GUEST}}}
		<div class="gb_welcome">{WELCOME_MSG}</div>
		{+START,IF_NON_EMPTY,{WHATS_THIS}}
			<div class="gb_help">{WHATS_THIS}{WHATS_THIS_LINK}</div>
		{+END}
		<div class="gb_credits_available">{CREDITS_AVAILABLE}</div>		
	{+END}	
</div>