{+START,SET,ticket_page_existing_text}
	{+START,IF_PASSED,TICKET_TYPE_ID}{+START,IF,{$EQ,{TICKET_TYPE_ID},8}}
		<p>When replying to an existing ticket, please bear the following in mind regarding follow-up questions:</p>
		<ol>
			<li>
				Tangentially-related questions are best in a new ticket: meandering tickets take more time to assign/track so can end in higher credit charges.
			</li>
			<li>
				Even in the same ticket, follow-up questions may need to be funded by some extra credits, particularly if they could not be anticipated.
			</li>
		</ol>
	{+END}{+END}
{+END}

{+START,INCLUDE,SUPPORT_TICKET_SCREEN}{+END}
