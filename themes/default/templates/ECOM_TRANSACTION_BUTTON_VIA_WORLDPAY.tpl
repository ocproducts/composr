<form title="{!MAKE_PAYMENT}" class="ecommerce_button" action="{FORM_URL*}" method="post" autocomplete="off">
	<input type="hidden" name="instId" value="{USERNAME*}" />
	<input type="hidden" name="MC_callback" value="{$REPLACE,https://,,{$REPLACE,http://,,{$FIND_SCRIPT*,ecommerce}?from=worldpay&amp;type_code={TYPE_CODE*}}}" />
	<input type="hidden" name="cartId" value="{TRANS_ID*}" />
	<input type="hidden" name="amount" value="{AMOUNT*}" />
	<input type="hidden" name="currency" value="{CURRENCY*}" />
	<input type="hidden" name="desc" value="{ITEM_NAME*}" />
	{+START,IF,{TEST_MODE}}
		<input type="hidden" name="testMode" value="100" />
	{+END}
	<input type="hidden" name="email" value="{EMAIL_ADDRESS*}" />
	<input type="hidden" name="lang" value="{$LANG*}" />
	<input type="hidden" name="signatureFields" value="cartId:amount:currency" />
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

	<div class="purchase_button">
		<input data-disable-on-click="1" class="button_screen menu__rich_content__ecommerce__purchase" type="submit" value="{!MAKE_PAYMENT}" />
	</div>
</form>
