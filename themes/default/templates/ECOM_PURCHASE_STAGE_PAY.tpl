{$,Template is used for remote payments only; local payments use ECOM_PURCHASE_STAGE_TRANSACT}
{$REQUIRE_JAVASCRIPT,ecommerce}
<div data-tpl="ecomPurchaseStagePay" data-tpl-params="{+START,PARAMS_JSON,TYPE_CODE}{_*}{+END}">
	{$,You may want to put in some JavaScript to auto-click the payment button, at least for some TYPE_CODE values, as this step is usually over-complex; we do for CART_ORDER_* by default}

	{+START,IF_PASSED,CONFIRMATION_BOX}
		<div class="box box___ecom_purchase_stage_pay"><div class="box-inner">
			{CONFIRMATION_BOX}
		</div></div>
	{+END}

	{+START,IF_PASSED,TEXT}
		{$PARAGRAPH,{TEXT}}
	{+END}
	{+START,IF_NON_PASSED,TEXT}
		<p>{!PURCHASE_STORED_DETAILS}</p>
	{+END}

	{+START,IF_NON_EMPTY,{LOGOS}{PAYMENT_PROCESSOR_LINKS}}
		<div class="local-payment-merchant-details"><div>
			{+START,IF_NON_EMPTY,{PAYMENT_PROCESSOR_LINKS}}
				<div class="payment-processor-links">
					{PAYMENT_PROCESSOR_LINKS}
				</div>
			{+END}

			{+START,IF_NON_EMPTY,{LOGOS}}
				<div class="local-payment-verified-account-logo">
					{LOGOS}
				</div>
			{+END}
		</div></div>
	{+END}

	{TRANSACTION_BUTTON}
</div>
