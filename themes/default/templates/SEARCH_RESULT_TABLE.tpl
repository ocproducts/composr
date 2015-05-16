<div class="wide_table_wrap"><table class="columned_table wide_table results_table autosized_table">
	<thead>
		<tr>
			{+START,LOOP,HEADERS}
				<th>{_loop_var*}</th>
			{+END}
		</tr>
	</thead>

	<tbody>
		{+START,LOOP,ROWS}
			<tr>
				{+START,LOOP,R}
					<td>{_loop_var}</td>
				{+END}
			</tr>
		{+END}
	</tbody>
</table></div>
