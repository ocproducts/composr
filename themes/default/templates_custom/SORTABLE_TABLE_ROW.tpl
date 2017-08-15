{+START,SET,tooltip}
	{+START,IF_NON_EMPTY,{TOOLTIP_VALUES}}
		<div class="wide_table_wrap"><table class="results_table wide_table map_table">
			<tbody>
				{+START,LOOP,TOOLTIP_VALUES}
					<tr>
						<th>{_loop_key*}</th>
						<td>{_loop_var*}</td>
					</tr>
				{+END}
			</tbody>
		</table></div>
	{+END}
{+END}

<tr{+START,IF_NON_EMPTY,{$TRIM,{$GET,tooltip}}} style="cursor: pointer" data-mouseover-activate-tooltip="['{$GET*;^,tooltip}','auto']"{+END}>
	{+START,LOOP,VALUES}
		{$SET,header,{+START,OF,{_loop_key}}HEADERS{+END}}
		<td data-th="{$GET*,header}" style="{+START,OF,STYLINGS}{_loop_key}{+END}">{_loop_var*}</td>
	{+END}
</tr>
