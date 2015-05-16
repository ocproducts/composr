{$SET,rowspan_detected,0}

{+START,IF_NON_EMPTY,{$TRIM,{HOURS}}}
	<table class="map_table calendar_day_table autosized_table">
		<tbody>
			{HOURS}
		</tbody>
	</table>
{+END}
