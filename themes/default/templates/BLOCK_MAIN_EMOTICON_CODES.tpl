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
		{ROWS}
	</tbody>
</table>
