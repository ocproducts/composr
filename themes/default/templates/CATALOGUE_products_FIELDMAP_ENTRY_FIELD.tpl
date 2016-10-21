{$,The IF filter makes sure we only show fields we haven't shown elsewhere (hard-coded list)}
{+START,IF,{$NEQ,{FIELDID},0,1,2,3,9,7}}{+START,IF,{$NEQ,{VALUE},,{!NA_EM}}}
	{+START,IF,{$PREG_MATCH,^.*: ,{FIELD}}}
		{$SET,next_title,{$PREG_REPLACE,: .*$,,{FIELD}}}
		{+START,IF,{$NEQ,{$GET,just_done_title},{$GET,next_title}}}
			<tr class="form_table_field_spacer">
				<th colspan="2" class="table_heading_cell vertical_alignment">
					<h3>{$GET*,next_title}</h3>
				</th>
			</tr>
		{+END}
		{$SET,just_done_title,{$GET,next_title}}
	{+END}

	<tr>
		<th width="30%">{$PREG_REPLACE,^.*: ,,{FIELD*}}</th>
		<td width="70%">{VALUE}</td>
	</tr>
{+END}{+END}
