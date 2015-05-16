<h2>{FIELD*}</h2>

<table class="columned_table autosized_table results_table spaced_table">
	<thead>
		<tr>
			<th>{!KEYWORD}</th>
			<th>{!DENSITY}</th>
			<th>{!IDEAL_DENSITY}</th>
		</tr>
	</thead>
	<tbody>
		{+START,LOOP,KEYWORDS}
			<tr>
				<td>{KEYWORD*}</td>
				<td>{DENSITY*}%</td>
				<td>{IDEAL_DENSITY*}%</td>
			</tr>
		{+END}
	</tbody>
</table>

