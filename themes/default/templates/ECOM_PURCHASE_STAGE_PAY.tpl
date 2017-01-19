{$,Template is used for remote payments only; local payments use ECOM_PURCHASE_STAGE_TRANSACT}

{$,You may want to put in some JavaScript to auto-click the payment button, at least for some TYPE_CODE values, as this step is usually over-complex}

{+START,IF_PASSED,TEXT}
	{$PARAGRAPH,{TEXT}}
{+END}
{+START,IF_NON_PASSED,TEXT}
	<p>{!PURCHASE_STORED_DETAILS}</p>
{+END}

{+START,IF_PASSED,CONFIRMATION_BOX}
	<p>
		{!CONFIRM_TEXT}
	</p>

	<div class="box box___ecom_purchase_stage_pay"><div class="box_inner">
		{CONFIRMATION_BOX}
	</div></div>
{+END}

{+START,IF_NON_EMPTY,{LOGOS}{PAYMENT_PROCESSOR_LINKS}}
	<div class="local_payment_merchant_details"><div>
		{+START,IF_NON_EMPTY,{PAYMENT_PROCESSOR_LINKS}}
			<div class="payment_processor_links">
				{PAYMENT_PROCESSOR_LINKS}
			</div>
		{+END}

		{+START,IF_NON_EMPTY,{LOGOS}}
			<div class="local_payment_verified_account_logo">
				{LOGOS}
			</div>
		{+END}
	</div></div>
{+END}

{TRANSACTION_BUTTON}
