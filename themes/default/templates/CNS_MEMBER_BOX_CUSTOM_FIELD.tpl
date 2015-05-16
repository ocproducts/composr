{+START,IF_NON_EMPTY,{VALUE}}
	{+START,IF,{$NOT,{$GET,fancy_screen}}}
		<tr>
			<th class="de_th">{$REPLACE,/, / ,{NAME*}}:</th>
			<td>{VALUE}</td>
		</tr>
	{+END}

	{+START,IF,{$GET,fancy_screen}}
		{+START,IF,{$GET,main}}
			<div class="associated_details">{$TRUNCATE_LEFT,{VALUE},40,1,1}</div>
		{+END}
		{+START,IF,{$NOT,{$GET,main}}}
			<tr>
				<th class="de_th">{$REPLACE,/, / ,{NAME*}}:</th>
				<td>{$TRUNCATE_LEFT,{VALUE},40,1,1}</td>
			</tr>
		{+END}
	{+END}
{+END}
