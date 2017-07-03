<tr>
	<th class="de_th form_table_field_name">
		<span class="field_name">{NICE_NAME*}</span>
		{+START,IF_NON_EMPTY,{DESCRIPTION}}
			<div class="associated_details">{DESCRIPTION}</div>
		{+END}
	</th>

	<td class="form_table_field_input">
		<div class="accessibility_hidden"><label for="{NAME*}">{NICE_NAME*}</label></div>
		<div>
			{INPUT}
		</div>
	</td>
</tr>
