{+START,IF_PASSED,POP3_URL}
	<p class="associated_link suggested_link"><a href="{POP3_URL*}">{!ENTER}: {!POP3}</a></p>
{+END}
{+START,IF_NON_PASSED,POP3_URL}
	<p class="nothing_here">
		{!NO_POP3S}
	</p>
{+END}

