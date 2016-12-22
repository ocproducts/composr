<tr class="{$CYCLE,results_table_zebra,zebra_0,zebra_1}">
	<th{+START,IF,{$MOBILE}} style="text-align: left"{+END}>
		{NAME*}
	</th>

	{+START,IF,{$MOBILE}}
	</tr>
	<tr>
	{+END}

	<td>
		{VALUE*}
	</td>
</tr>

