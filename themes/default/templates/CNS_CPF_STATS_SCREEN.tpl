{TITLE}

<div class="wide_table_wrap"><table class="columned_table autosized_table wide_table results_table spaced_table">
	<thead>
		<tr>
			<th>{!CHOICE}</th>
			<th>{!COUNT_MEMBERS}</th>
		</tr>
	</thead>

	<tbody>
		{+START,LOOP,STATS}
			<tr>
				<td>
					{+START,IF_EMPTY,{VAL}}{!BLANK_EM}{+END}

					{+START,IF_NON_EMPTY,{VAL}}{VAL*}{+END}
				</td>
				<td>
					{CNT*}
				</td>
			</tr>
		{+END}
	</tbody>
</table></div>

