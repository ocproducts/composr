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
				<th><span>{!FC_SUNDAY}</span></th>
				{+END}
				<th><span>{!FC_MONDAY}</span></th>
				<th><span>{!FC_TUESDAY}</span></th>
				<th><span>{!FC_WEDNESDAY}</span></th>
				<th><span>{!FC_THURSDAY}</span></th>
				<th><span>{!FC_FRIDAY}</span></th>
				<th><span>{!FC_SATURDAY}</span></th>
				{+START,IF,{$NOT,{$SSW}}}
				<th><span>{!FC_SUNDAY}</span></th>
				{+END}
			</tr>
		</thead>

		<tbody>
			{ENTRIES}
		</tbody>
	</table>
</td>
