{$,Read the catalogue tutorial for information on custom catalogue layouts}

{+START,IF_NON_EMPTY,{VALUE}}
	{+START,IF,{$PREG_MATCH,^.*: ,{FIELD}}}
		{$SET,next_title,{$PREG_REPLACE,: .*$,,{FIELD}}}
		{+START,IF,{$NEQ,{$GET,just_done_title},{$GET,next_title}}}
			<tr class="form-table-field-spacer">
				<th colspan="2" class="table-heading-cell vertical-alignment">
					<h3>{$GET*,next_title}</h3>
				</th>
			</tr>
		{+END}
		{$SET,just_done_title,{$GET,next_title}}
	{+END}

	<tr class="field_{FIELDID*} fieldid_{_FIELDID*}">
		<th>{$PREG_REPLACE,^.*: ,,{FIELD*}}</th>
		<td>{VALUE}</td>
	</tr>
{+END}
