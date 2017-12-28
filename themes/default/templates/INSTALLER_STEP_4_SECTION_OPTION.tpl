<tr>
	<th class="de_th form-table-field-name">
		<span class="field-name">{NICE_NAME*}</span>
		{+START,IF_NON_EMPTY,{DESCRIPTION}}
			<div class="associated-details">{DESCRIPTION}</div>
		{+END}
	</th>

	<td class="form-table-field-input">
		<div class="accessibility_hidden"><label for="{NAME*}">{NICE_NAME*}</label></div>
		<div>
			{INPUT}
		</div>
	</td>
</tr>
