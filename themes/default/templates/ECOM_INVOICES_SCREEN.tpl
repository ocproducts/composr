{TITLE}

<div class="wide_table_wrap"><table class="columned_table wide_table results_table autosized_table responsive-table" itemprop="significantLinks">
	<thead>
		<tr>
			<th>{!NAME}</th>
			<th>{!AMOUNT}</th>
			<th>{$TAX_LABEL}</th>
			<th>{!DATE_TIME}</th>
			{+START,IF,{$DESKTOP}}
				<th>{!STATUS}</th>
			{+END}
			<th>{!ACTIONS}</th>
		</tr>
	</thead>

	<tbody>
		{+START,LOOP,INVOICES}
			{$SET,cycle,{$CYCLE,results_table_zebra,zebra_0,zebra_1}}

			<tr class="{$GET,cycle} thick_border">
				<td>
					<strong>{INVOICE_TITLE*}</strong>

					<p class="assocated_details block_mobile">
						<span class="field-name">{!STATUS}:</span> {STATE*}
					</p>
				</td>
				<td>
					{$CURRENCY,{AMOUNT},{CURRENCY},{$?,{$CONFIG_OPTION,currency_auto},{$CURRENCY_USER},{$CURRENCY}}}
				</td>
				<td>
					{$CURRENCY,{TAX},{CURRENCY},{$?,{$CONFIG_OPTION,currency_auto},{$CURRENCY_USER},{$CURRENCY}}}
				</td>
				<td>
					{DATE*}
				</td>
				{+START,IF,{$DESKTOP}}
					<td class="cell_desktop">
						{STATE*}
					</td>
				{+END}
				<td>
					{+START,IF,{PAYABLE}}
						{TRANSACTION_BUTTON}
					{+END}
					{+START,IF,{$HAS_ACTUAL_PAGE_ACCESS,admin_invoices}}
						<ul class="horizontal-links horiz-field-sep">
							<li><a class="button_screen_item menu___generic_admin__delete" href="{$PAGE_LINK*,adminzone:admin_invoices:delete:{INVOICE_ID}}"><span>{!DELETE}: #{INVOICE_ID}</span></a></li>
							{+START,IF,{FULFILLABLE}}
								<li><a title="{!MARK_AS_FULFILLED}: #{INVOICE_ID}" href="{$PAGE_LINK*,adminzone:admin_invoices:fulfill:{INVOICE_ID}}">{!FULFILL}</a></li>
							{+END}
						</ul>
					{+END}
				</td>
			</tr>
			{+START,IF_NON_EMPTY,{NOTE}}
				<tr class="{$GET,cycle}">
					<td class="responsive-table-no-prefix" colspan="6">
						{NOTE*}
					</td>
				</tr>
			{+END}
		{+END}
	</tbody>
</table></div>
