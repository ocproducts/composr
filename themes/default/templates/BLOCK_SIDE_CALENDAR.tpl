<section class="box box___block_side_calendar"><div class="box_inner">
	<h3><a href="{CALENDAR_URL*}" title="{!CALENDAR}: {MONTH*}">{!CALENDAR}</a><!-- &ndash; {MONTH*}--></h3>

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
					<th>{!FC_SUNDAY}</th>
					{+END}
					<th>{!FC_MONDAY}</th>
					<th>{!FC_TUESDAY}</th>
					<th>{!FC_WEDNESDAY}</th>
					<th>{!FC_THURSDAY}</th>
					<th>{!FC_FRIDAY}</th>
					<th>{!FC_SATURDAY}</th>
					{+START,IF,{$NOT,{$SSW}}}
					<th>{!FC_SUNDAY}</th>
					{+END}
				</tr>
			</thead>

			<tbody>
				{ENTRIES}
			</tbody>
		</table></div>
	</div>
</div></section>
