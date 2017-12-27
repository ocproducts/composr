{+START,IF_NON_EMPTY,{TAGS}}
	<div class="wide-table-wrap"><table class="columned_table autosized_table results-table wide-table">
		<thead>
			<tr>
				<th>{!TITLE}</th>
				<th>{!DESCRIPTION}</th>
				<th>{!EXAMPLE}</th>
			</tr>
		</thead>

		<tbody>
			{+START,LOOP,TAGS}
				<tr>
					<td>{TITLE*}</td>
					<td>{DESCRIPTION*}</td>
					<td><kbd>{EXAMPLE*}</kbd></td>
				</tr>
			{+END}
		</tbody>
	</table></div>
{+END}
{+START,IF_EMPTY,{TAGS}}
	<p class="nothing_here">{!NONE}</p>
{+END}
