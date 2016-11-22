{+START,IF_PASSED,TEXT}
	{$PARAGRAPH,{TEXT}}
{+END}

<p>{!TRANSACT_INFO}</p>

{HIDDEN}

TODO: Use VERIFIED_ACCOUNT_LOGO

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

