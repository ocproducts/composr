<form title="{!MAKE_PAYMENT}" class="left" action="{IPN_URL*}" method="post" autocomplete="off">
	<input type="hidden" name="cmd" value="_xclick-subscriptions" />
	<input type="hidden" name="charset" value="{!charset}" />
	<input type="hidden" name="business" value="{PAYMENT_ADDRESS*}" />
	<input type="hidden" name="notify_url" value="{$FIND_SCRIPT*,ecommerce,1}?from=paypal&amp;type_code={TYPE_CODE*}" />
	<input type="hidden" name="no_shipping" value="1" />
	<input type="hidden" name="return" value="{$PAGE_LINK*,_SEARCH:purchase:finish:type_code={TYPE_CODE}:from=paypal}" />
	<input type="hidden" name="cancel_return" value="{$PAGE_LINK*,_SEARCH:purchase:finish:cancel=1:from=paypal}" />
	<input type="hidden" name="currency_code" value="{CURRENCY*}" />
	<input type="hidden" name="custom" value="{PURCHASE_ID*}" />
	<input type="hidden" name="a3" value="{AMOUNT*}" />
	<input type="hidden" name="p3" value="{LENGTH*}" />
	<input type="hidden" name="t3" value="{$UCASE*,{LENGTH_UNITS}}" />
	<input type="hidden" name="src" value="1" />
	<input type="hidden" name="sra" value="1" />
	<input type="hidden" value="1" name="no_note" />
	<input type="hidden" value="{!SUBSCRIPTION_FOR,{$USERNAME*},{ITEM_NAME*}}" name="item_name" />
	<input type="hidden" name="rm" value="2" />
	<input type="hidden" name="bn" value="ocproducts_SP" />

	<div class="purchase_button">
		<input style="border: 0px" type="image" src="https://www.paypal.com/en_US/i/btn/x-click-but23.gif" name="submit" alt="Make payments with PayPal - it's fast, free and secure!" />
	</div>
</form>

