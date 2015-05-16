{+START,IF_PASSED,FORWARDING_URL}
	<p class="associated_link suggested_link"><a href="{FORWARDING_URL*}">{!ENTER}: {!FORWARDING}</a></p>
{+END}
{+START,IF_NON_PASSED,FORWARDING_URL}
	<p class="nothing_here">
		{!NO_FORWARDINGS}
	</p>
{+END}

