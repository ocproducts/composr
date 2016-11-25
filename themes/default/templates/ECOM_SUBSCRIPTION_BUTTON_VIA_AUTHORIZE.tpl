<form class="left" action="{FORM_URL*}" method="post">
	<input type="hidden" name="x_fp_sequence" value="{SEQUENCE*}" />
	<input type="hidden" name="x_fp_timestamp" value="{TIMESTAMP*}" />
	<input type="hidden" name="x_fp_hash" value="{FINGERPRINT*}" />
	<input type="hidden" name="x_description" value="{PURCHASE_ID*}" />
	<input type="hidden" name="x_login" value="{LOGIN_ID*}" />
	<input type="hidden" name="x_amount" value="{AMOUNT*}" />
	<input type="hidden" name="x_show_form" value="PAYMENT_FORM" />
	<input type="hidden" name="x_test_request" value="{$?,{IS_TEST},TRUE,FALSE}" />
	<input type="hidden" name="x_cust_id" value="{CUST_ID*}" />
	<input type="hidden" name="x_currency_code" value="{CURRENCY*}" />
	<input type="hidden" name="x_relay_response" value="TRUE" />
	<input type="hidden" name="x_relay_url" value="{$PAGE_LINK*,_SEARCH:purchase:finish:type_code={TYPE_CODE}:from=authorize}" />
	<input type="hidden" name="x_recurring_billing" value="TRUE" />

	<div class="purchase_button">
		<input style="border: 0px" type="image" src="https://www.authorize.net/resources/images/merchants/products/buy_now_blue.gif" name="submit" alt="Authorize.net - Simple Checkout" />
	</div>
</form>
