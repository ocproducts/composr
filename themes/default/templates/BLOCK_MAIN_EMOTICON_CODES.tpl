<table class="columned_table autosized_table results_table">
	<thead>
		{$SET,i,0}
		<tr>
			{+START,WHILE,{$LT,{$GET,i},{NUM_COLUMNS}}}
				<th>{!CODE}</th>
				<th>{!IMAGE}</th>
				{$INC,i}
			{+END}
		</tr>
	</thead>

	<tbody>
		{+START,LOOP,ROWS}
			<tr class="zebra_{$CYCLE*,emoticon_rows,0,1}">
				{+START,LOOP,COLUMNS}
					<td>{CODE*}</td>
					<td>{TPL}</td>
				{+END}
			</tr>
		{+END}
	</tbody>
</table>
