{$REQUIRE_JAVASCRIPT,ecommerce}
<div data-tpl="ecomPurchaseStageDetails" data-tpl-params="{+START,PARAMS_JSON,JS_FUNCTION_CALLS}{_*}{+END}">
	{+START,IF_PASSED,TEXT}
		{$PARAGRAPH,{TEXT}}
	{+END}

	{+START,IF_PASSED,FIELDS}
		<div class="wide-table-wrap"><table class="map_table form-table wide-table">
			{+START,IF,{$DESKTOP}}
				<colgroup>
					<col class="purchase-field-name-column" />
					<col class="purchase-field-input-column" />
				</colgroup>
			{+END}

			<tbody>
				{FIELDS}
			</tbody>
		</table></div>
	{+END}
</div>
