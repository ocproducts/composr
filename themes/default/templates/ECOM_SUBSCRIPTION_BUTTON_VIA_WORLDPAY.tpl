<form title="{!MAKE_PAYMENT}" class="left" action="{IPN_URL*}" method="post" autocomplete="off">
	<input type="hidden" name="instId" value="{USERNAME*}" />
	<input type="hidden" name="MC_callback" value="{$REPLACE,https://,,{$REPLACE,http://,,{$FIND_SCRIPT*,ecommerce}?from=worldpay&amp;type_code={TYPE_CODE*}}}" />
	<input type="hidden" name="cartId" value="{PURCHASE_ID*}" />
	<input type="hidden" name="amount" value="{AMOUNT*}" />
	<input type="hidden" name="currency" value="{CURRENCY*}" />
	<input type="hidden" name="desc" value="{ITEM_NAME*}" />
	{+START,IF,{TEST_MODE}}
		<input type="hidden" name="testMode" value="100" />
	{+END}
	<input type="hidden" name="email" value="{EMAIL_ADDRESS*}" />
	<input type="hidden" name="lang" value="{$LANG*}" />
	<input type="hidden" name="signatureFields" value="cartId:amount:currency:intervalUnit:intervalMult" />
	<input type="hidden" name="signature" value="{DIGEST*}" />

	<input type="hidden" name="futurePayType" value="regular" />
	<input type="hidden" name="startDate" value="{FIRST_REPEAT*}" />
	<input type="hidden" name="normalAmount" value="{AMOUNT*}" />
	<input type="hidden" name="intervalMult" value="{LENGTH*}" />
	<input type="hidden" name="intervalUnit" value="{LENGTH_UNITS_2*}" />
	<input type="hidden" name="option" value="0" />

	<div class="purchase_button">
		<input onclick="disable_button_just_clicked(this);" class="button_screen menu__adminzone__audit__ecommerce__subscriptions" type="submit" value="{!MAKE_PAYMENT}" />
	</div>
</form>

