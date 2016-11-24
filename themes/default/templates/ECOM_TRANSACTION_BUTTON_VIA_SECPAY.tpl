<form title="{!MAKE_PAYMENT}" class="left" action="{IPN_URL*}" method="post" autocomplete="off">
	<input type="hidden" name="trans_id" value="{TRANS_ID*}" />
	<input type="hidden" name="merchant" value="{USERNAME*}" />
	<input type="hidden" name="digest" value="{DIGEST*}" />
	<input type="hidden" name="amount" value="{AMOUNT*}" />
	<input type="hidden" name="callback" value="{$FIND_SCRIPT*,ecommerce}?from=secpay&amp;type_code={TYPE_CODE*}" />
	<input type="hidden" name="currency" value="{CURRENCY*}" />
	<input type="hidden" name="cb_post" value="true" />
	<input type="hidden" name="req_cv2" value="true" />
	{+START,IF,{TEST}}
		<input type="hidden" name="test_status" value="true" />
	{+END}
	<input type="hidden" name="md_flds" value="trans_id:req_cv2" />

	<div class="purchase_button">
		<input onclick="disable_button_just_clicked(this);" class="button_screen menu__rich_content__ecommerce__purchase" type="submit" value="{!MAKE_PAYMENT}" />
	</div>
</form>

