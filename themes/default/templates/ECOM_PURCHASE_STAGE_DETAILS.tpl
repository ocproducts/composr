{$REQUIRE_JAVASCRIPT,ecommerce}
<div data-tpl="ecomPurchaseStageDetails" data-tpl-params="{+START,PARAMS_JSON,JS_FUNCTION_CALLS}{_*}{+END}">
	{+START,IF_PASSED,TEXT}
		{$PARAGRAPH,{TEXT}}
	{+END}

	{+START,IF_PASSED,FIELDS}
		<div class="wide_table_wrap"><table class="map_table form_table wide_table">
			{+START,IF,{$DESKTOP}}
				<colgroup>
					<col class="purchase_field_name_column" />
					<col class="purchase_field_input_column" />
				</colgroup>
			{+END}

			<tbody>
				{FIELDS}
			</tbody>
		</table></div>
	{+END}
</div>
