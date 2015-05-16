<div class="box box___community_billboard_details"><div class="box_inner">
	<h2>{!DETAILS}</h2>

	<div class="wide_table_wrap"><table class="map_table wide_table results_table">
		{+START,IF,{$NOT,{$MOBILE}}}
			<colgroup>
				<col class="field_name_column" />
				<col class="field_value_column" />
			</colgroup>
		{+END}

		<tbody>
			{+START,IF_PASSED,MESSAGE}
				<tr>
					<th>
						{!MESSAGE}
					</th>
					<td>
						{MESSAGE}
					</td>
				</tr>
			{+END}

			{+START,IF_PASSED,DAYS}
				<tr>
					<th>{!_UP_FOR}</th>
					<td>{!DAYS,{DAYS*}}</td>
				</tr>
			{+END}

			<tr>
				<th>{!SUBMITTER}</th>
				<td>{USERNAME}</td>
			</tr>

			<tr>
				<th>{!DAYS_ORDERED}</th>
				<td>{DAYS_ORDERED*}</td>
			</tr>

			<tr>
				<th>{!ORDER_DATE}</th>
				<td>{DATE*}</td>
			</tr>
		</tbody>
	</table></div>
</div></div>

