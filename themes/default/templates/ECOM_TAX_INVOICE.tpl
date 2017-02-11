<div class="invoice_box">
	<table><tbody>
		<tr class="top">
			<td colspan="2">
				<table><tbody>
					<tr>
						<td class="title">
							<img alt="{$SITE_NAME*}" src="{$IMG*,logo/standalone_logo}" /><br />
							{+START,IF_NON_EMPTY,{$CONFIG_OPTION,tax_number}}
								<br />{$TAX_NUMBER_LABEL} {$CONFIG_OPTION,tax_number}
							{+END}
						</td>

						<td>
							{!INVOICE} #: {TXN_ID*}<br />
							{!STATUS}: {DATE*}
						</td>
					</tr>
				</tbody></table>
			</td>
		</tr>

		<tr class="information">
			<td colspan="2">
				<table><tbody>
					<tr>
						<td>
							{$REPLACE,
,<br />,{$CONFIG_OPTION*,business_address}}
						</td>

						<td>
							{$REPLACE,
,<br />,{TRANS_ADDRESS*}}
						</td>
					</tr>
				</tbody></table>
			</td>
		</tr>

		<tr class="heading">
			<td>
				{!IDENTIFIER}
			</td>

			<td>
				{!ITEM_NAME}
			</td>

			<td>
				{!QUANTITY}
			</td>

			<td>
				{!UNIT_PRICE}
			</td>

			<td>
				{!PRICE}
			</td>

			<td>
				{$TAX_LABEL}
			</td>
		</tr>

		{+START,LOOP,ITEMS}
			<tr class="item">
				<td>
					{TYPE_CODE*}
				</td>

				<td>
					{ITEM_NAME*}
				</td>

				<td>
					{QUANTITY*}
				</td>

				<td>
					{CURRENCY_SYMBOL*}{UNIT_PRICE*}
				</td>

				<td>
					{CURRENCY_SYMBOL*}{PRICE*}
				</td>

				<td>
					{CURRENCY_SYMBOL*}{TAX*} ({TAX_RATE*}%)
				</td>
			</tr>
		{+END}

		<tr class="total">
			<td colspan="4"></td>

			<td>
				{CURRENCY_SYMBOL*}{TOTAL_PRICE*}
			</td>

			<td>
				{CURRENCY_SYMBOL*}{TOTAL_TAX*}
			</td>
		</tr>

		<tr class="total">
			<td colspan="6">
				{!GRAND_TOTAL}: {CURRENCY_SYMBOL*}{TOTAL_AMOUNT*}
			</td>
		</tr>
	</tbody></table>
</div>
