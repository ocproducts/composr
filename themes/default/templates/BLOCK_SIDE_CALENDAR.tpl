<div class="side_calendar_wrap">
	<div class="wide_table_wrap_internal_borders"><table class="spread_table autosized_table wide_table side_calendar calendar_year_month_table">
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
				<th title="{!SUNDAY}">{!FC_SUNDAY}</th>
				{+END}
				<th title="{!MONDAY}">{!FC_MONDAY}</th>
				<th title="{!TUESDAY}">{!FC_TUESDAY}</th>
				<th title="{!WEDNESDAY}">{!FC_WEDNESDAY}</th>
				<th title="{!THURSDAY}">{!FC_THURSDAY}</th>
				<th title="{!FRIDAY}">{!FC_FRIDAY}</th>
				<th title="{!SATURDAY}">{!FC_SATURDAY}</th>
				{+START,IF,{$NOT,{$SSW}}}
				<th title="{!SUNDAY}">{!FC_SUNDAY}</th>
				{+END}
			</tr>
		</thead>

		<tbody>
			{ENTRIES}
		</tbody>
	</table></div>
</div>
