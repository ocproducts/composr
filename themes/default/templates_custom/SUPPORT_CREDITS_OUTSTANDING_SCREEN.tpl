<h2>{TITLE}</h2>

<div class="link-exempt-wrap">
	{DATA}
</div>

{+START,IF_NON_PASSED,NO_CSV}
	<p>
		<a href="{$SELF_URL*}&amp;csv=1" class="xls-link">{!EXPORT_STATS_TO_CSV}</a>
	</p>
{+END}
