<form title="{!MAKE_PAYMENT}" class="ecommerce-button" action="{FORM_URL*}" method="post">
	<input type="hidden" name="instId" value="{USERNAME*}" />
	<input type="hidden" name="MC_callback" value="{$REPLACE,https://,,{$REPLACE,http://,,{$FIND_SCRIPT*,ecommerce}?from=worldpay&amp;type_code={TYPE_CODE*}}}" />
	<input type="hidden" name="cartId" value="{TRANS_EXPECTING_ID*}" />
	<input type="hidden" name="amount" value="{AMOUNT*}" />
	<input type="hidden" name="currency" value="{CURRENCY*}" />
	<input type="hidden" name="desc" value="{!SUBSCRIPTION_FOR,{$USERNAME*}} ({ITEM_NAME*})" />
	{+START,IF,{TEST_MODE}}
		<input type="hidden" name="testMode" value="100" />
	{+END}
	<input type="hidden" name="email" value="{EMAIL_ADDRESS*}" />
	<input type="hidden" name="lang" value="{$LANG*}" />
	<input type="hidden" name="signatureFields" value="cartId:amount:currency:intervalUnit:intervalMult" />
	<input type="hidden" name="signature" value="{DIGEST*}" />
	{+START,IF_NON_EMPTY,{MEMBER_ADDRESS}}
		{+START,LOOP,MEMBER_ADDRESS}
			{+START,IF_NON_EMPTY,{_loop_key*}}
				{+START,IF_NON_EMPTY,{_loop_var*}}
					<input type="hidden" name="{_loop_key*}" value="{_loop_var*}" />
				{+END}
			{+END}
		{+END}
	{+END}

	<input type="hidden" name="futurePayType" value="regular" />
	<input type="hidden" name="startDate" value="{FIRST_REPEAT*}" />
	<input type="hidden" name="normalAmount" value="{AMOUNT*}" />
	<input type="hidden" name="intervalMult" value="{LENGTH*}" />
	<input type="hidden" name="intervalUnit" value="{LENGTH_UNITS_2*}" />
	<input type="hidden" name="option" value="0" />

	<div class="purchase-button">
		<button id="purchase-button" data-disable-on-click="1" class="btn btn-primary btn-scr menu--adminzone--audit--ecommerce--subscriptions" type="submit">{+START,INCLUDE,ICON}NAME=menu/adminzone/audit/ecommerce/subscriptions{+END} {!MAKE_PAYMENT}</button>
	</div>
</form>
