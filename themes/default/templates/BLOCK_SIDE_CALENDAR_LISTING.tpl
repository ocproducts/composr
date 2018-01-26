<section class="box box___block_side_calendar_listing"><div class="box_inner">
	<h3>{TITLE*}</h3>

	<div>{$,So that the titles don't have box titling CSS}
		{+START,IF_EMPTY,{DAYS}}
			<p class="nothing_here">{!NO_ENTRIES,event}</p>
		{+END}
		{+START,LOOP,DAYS}
			<h4 class="event_listing_day">{DATE*}</h4>

			<div class="wide_table_wrap">
				<table class="map_table results_table wide_table events_listing_table autosized_table">
					<colgroup>
						<col class="event_listing_col_1" />
						<col class="event_listing_col_2" />
						<col class="event_listing_col_3" />
					</colgroup>

					<tbody>
						{+START,LOOP,EVENTS}
							<tr class="vevent" itemscope="itemscope" itemtype="http://schema.org/Event">
								<th>
									{+START,IF_PASSED,ICON}{+START,IF_PASSED,T_TITLE}
										<img src="{$IMG*,{ICON}}" title="{T_TITLE*}" alt="{T_TITLE*}" />
									{+END}{+END}
								</th>

								<td{+START,IF,{$EQ,{TIME_WRITTEN},{!ALL_DAY_EVENT}}} style="display: none"{+END}>
									<time class="dtstart" datetime="{FROM_TIME_VCAL*}" itemprop="startDate">{$?,{$EQ,{FROM_TIME},{!ALL_DAY_EVENT}},{FROM_TIME_VCAL*},{FROM_TIME*}}</time>
								</td>

								<td{+START,IF,{$EQ,{FROM_TIME},{!ALL_DAY_EVENT}}} colspan="2"{+END}>
									<a href="{VIEW_URL*}" class="url" itemprop="name"><span class="summary">{E_TITLE*}</span></a>
									{+START,IF_PASSED,TO_TIME}
										<span{+START,IF,{$EQ,{FROM_TIME},{TO_TIME}}} style="display: none"{+END}>
											<span class="associated_details">({!EVENT_ENDS_ON,<time class="dtend" datetime="{TO_TIME_VCAL*}" itemprop="endDate">{TO_TIME*}</time>})</span>
										</span>
									{+END}
								</td>
							</tr>
						{+END}
					</tbody>
				</table>
			</div>
		{+END}
	</div>
</div></section>

