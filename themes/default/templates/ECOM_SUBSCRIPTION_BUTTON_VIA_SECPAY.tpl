<form title="{!MAKE_PAYMENT}" class="left" action="{IPN_URL*}" method="post" autocomplete="off">
	<input type="hidden" name="trans_id" value="subscr_{TRANS_ID*}" />
	<input type="hidden" name="merchant" value="{USERNAME*}" />
	<input type="hidden" name="digest" value="{DIGEST*}" />
	<input type="hidden" name="amount" value="{AMOUNT*}" />
	<input type="hidden" name="callback" value="{$FIND_SCRIPT*,ecommerce}?from=secpay&amp;type_code={TYPE_CODE*}" />
	<input type="hidden" name="repeat_callback" value="{$FIND_SCRIPT*,ecommerce}?from=secpay&amp;subc=1&amp;type_code={TYPE_CODE*}" />
	<input type="hidden" name="currency" value="{CURRENCY*}" />
	<input type="hidden" name="cb_post" value="true" />
	<input type="hidden" name="req_cv2" value="true" />
	{+START,IF,{TEST}}
		<input type="hidden" name="test_status" value="true" />
	{+END}
	<input type="hidden" name="md_flds" value="trans_id:req_cv2:repeat" />
	<input type="hidden" name="repeat" value="{FIRST_REPEAT*}/{LENGTH_UNITS_2*}/0/{PRICE*}" />

	<div>
		<input onclick="disable_button_just_clicked(this);" class="button_screen menu__adminzone__audit__ecommerce__subscriptions" type="submit" value="{!START_SUBSCRIPTION}" />
	</div>
</form>

