{+START,IF_PASSED,TEXT}
	{$PARAGRAPH,{TEXT}}
{+END}

{+START,IF_NON_EMPTY,{ERROR_MSG}}
   <div class="subscription_error">
      {!TRANSACTION_ERROR,{ERROR_MSG}}
   </div>
{+END}

<div class="local_payment_merchant_details">
	{+START,IF_NON_EMPTY,{LOGOS}{PAYMENT_PROCESSOR_LINKS}}
		<div class="local_payment_verified_account_logo">
			{+START,IF_NON_EMPTY,{LOGOS}}
				<div class="logos">
					{LOGOS}
				</div>
			{+END}

			{+START,IF_NON_EMPTY,{PAYMENT_PROCESSOR_LINKS}}
				<div class="payment_processor_links">
					{PAYMENT_PROCESSOR_LINKS}
				</div>
			{+END}
		</div>
	{+END}

	<div class="local_payment_transact_info">
		<p>{!TRANSACT_INFO}</p>
	</div>
</div>

<div class="wide_table_wrap"><table class="map_table form_table wide_table">
	{+START,IF,{$NOT,{$MOBILE}}}
		<colgroup>
			<col class="purchase_wizard_field_name_column" />
			<col class="purchase_wizard_field_input_column" />
		</colgroup>
	{+END}

	<tbody>
		{FIELDS}
	</tbody>
</table></div>

{HIDDEN}
