{$,Template is used for local payments only; may be embedded into shopping cart as well as serving in the purchasing module}

{+START,IF_PASSED,CONFIRMATION_BOX}
	<div class="box box___ecom_purchase_stage_transact"><div class="box_inner">
		{CONFIRMATION_BOX}
	</div></div>
{+END}

{+START,IF_PASSED,TEXT}
	{$PARAGRAPH,{TEXT}}
{+END}

{+START,IF_PASSED,FIELDS}
	<div class="local_payment_merchant_details_wrap"><div class="local_payment_merchant_details"><div>
		<div class="local_payment_transact_info">
			<p>{!TRANSACT_INFO}</p>
		</div>

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
	</div></div></div>

	<div class="wide_table_wrap"><table class="map_table form_table wide_table">
		{+START,IF,{$NOT,{$MOBILE}}}
			<colgroup>
				<col class="purchase_field_name_column" />
				<col class="purchase_field_input_column" />
			</colgroup>
		{+END}

		<tbody>
			{FIELDS}
		</tbody>
	</table></div>
{+END}

{+START,IF_PASSED,HIDDEN}
	{HIDDEN}
{+END}
