<h2>{TITLE}</h2>

<div class="link_exempt_wrap">
	{DATA}
</div>

{+START,IF_NON_PASSED,NO_CSV}
	<p>
		<a href="{$SELF_URL*}&amp;csv=1" class="xls_link">{!EXPORT_STATS_TO_CSV}</a>
	</p>
{+END}


