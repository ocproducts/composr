{TITLE}

{+START,IF_PASSED,TEXT}
	{$PARAGRAPH,{TEXT*}}
{+END}

<div class="wide-table-wrap"><table class="map-table wide-table results-table spaced-table autosized-table{+START,IF_PASSED_AND_TRUE,RESPONSIVE} responsive-blocked-table{+END}">
	<tbody>
		{FIELDS}
	</tbody>
</table></div>

{+START,IF_PASSED,BUTTONS}
	<div class="buttons-group">
		{BUTTONS}
	</div>
{+END}
