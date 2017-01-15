{$,Template is used for remote payments only; local payments use ECOM_PURCHASE_STAGE_TRANSACT}

{+START,IF_PASSED,TEXT}
	{$PARAGRAPH,{TEXT}}
{+END}

{+START,IF_NON_PASSED,TEXT}
	<p>{!PURCHASE_STORED_DETAILS}</p>
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
