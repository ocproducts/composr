<a id="group_{GROUP_NAME*}"></a>

<h3>{GROUP_TITLE*}</h3>

<div class="wide_table_wrap"><table class="map_table form_table wide_table">
	{+START,IF,{$NOT,{$MOBILE}}}
		<colgroup>
			<col class="field_name_column" />
			<col class="field_input_column" />
		</colgroup>
	{+END}

	<tbody>
		{+START,IF_NON_EMPTY,{GROUP_DESCRIPTION}}
			<tr class="form_table_field_spacer">
				<th{+START,IF,{$NOT,{$MOBILE}}} colspan="2"{+END} class="table_heading_cell">
					{GROUP_DESCRIPTION*}
				</th>
			</tr>
		{+END}

		{GROUP}
	</tbody>
</table></div>
