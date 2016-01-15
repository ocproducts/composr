{+START,IF_NON_EMPTY,{VALUE}}
	{+START,IF,{$NEQ,{FIELD},Name / Company,Latitude,Longitude,URL,Logo}}
		<tr class="field_{FIELDID*} fieldid_{_FIELDID*}">
			<th>{FIELD*}</th>
			<td>{VALUE}</td>
		</tr>
	{+END}
{+END}
