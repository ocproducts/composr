<form title="{!MAKE_PAYMENT}" class="ecommerce_button" action="{FORM_URL*}" method="post" autocomplete="off">
	<input type="hidden" name="trans_id" value="subscr_{TRANS_ID*}" /> {$,The "subscr_" is used by us to indicate it will be a subscription}
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
	{+START,IF_NON_EMPTY,{MEMBER_ADDRESS}}
		{+START,LOOP,MEMBER_ADDRESS}
			{+START,IF_NON_EMPTY,{_loop_key*}}
				{+START,IF_NON_EMPTY,{_loop_var*}}
					<input type="hidden" name="{_loop_key*}" value="{_loop_var*}" />
				{+END}
			{+END}
		{+END}
	{+END}

	<input type="hidden" name="repeat_callback" value="{$FIND_SCRIPT*,ecommerce}?from=secpay&amp;subc=1&amp;type_code={TYPE_CODE*}" />
	<input type="hidden" name="md_flds" value="trans_id:req_cv2:repeat" />
	<input type="hidden" name="repeat" value="{FIRST_REPEAT*}/{LENGTH_UNITS_2*}/0/{PRICE*}" />

	<div>
		<input data-disable-on-click="1" class="button_screen menu__adminzone__audit__ecommerce__subscriptions" type="submit" value="{!START_SUBSCRIPTION}" />
	</div>
</form>
