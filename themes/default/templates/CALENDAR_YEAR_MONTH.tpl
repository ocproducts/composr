<td class="calendar_year_month">
	<table class="spread_table calendar_year_month_table">
		<colgroup>
			<col class="calendar_weekly_column" />
			<col class="calendar_weekly_column" />
			<col class="calendar_weekly_column" />
			<col class="calendar_weekly_column" />
			<col class="calendar_weekly_column" />
			<col class="calendar_weekly_column" />
			<col class="calendar_weekly_column" />
		</colgroup>

		<thead>
			<tr>
				{+START,IF,{$SSW}}
				<th><span>{$SUBSTR,{!SUNDAY},0,1}</span></th>
				{+END}
				<th><span>{$SUBSTR,{!MONDAY},0,1}</span></th>
				<th><span>{$SUBSTR,{!TUESDAY},0,1}</span></th>
				<th><span>{$SUBSTR,{!WEDNESDAY},0,1}</span></th>
				<th><span>{$SUBSTR,{!THURSDAY},0,1}</span></th>
				<th><span>{$SUBSTR,{!FRIDAY},0,1}</span></th>
				<th><span>{$SUBSTR,{!SATURDAY},0,1}</span></th>
				{+START,IF,{$NOT,{$SSW}}}
				<th><span>{$SUBSTR,{!SUNDAY},0,1}</span></th>
				{+END}
			</tr>
		</thead>

		<tbody>
			{ENTRIES}
		</tbody>
	</table>
</td>
