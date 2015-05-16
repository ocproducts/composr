{+START,IF_PASSED,TEXT}
	{$PARAGRAPH,{TEXT}}
{+END}

<p>{!TRANSACT_INFO}</p>

{+START,IF_PASSED,HIDDEN}
	{HIDDEN}
{+END}

<div class="wide_table_wrap"><table class="map_table form_table wide_table">
	{+START,IF,{$NOT,{$MOBILE}}}
		<colgroup>
			<col class="purchase_wizard_field_name_column" />
			<col class="purchase_wizard_field_input_column" />
		</colgroup>
	{+END}

	<tbody>
		{FIELDS}
	</tbody>
</table></div>

