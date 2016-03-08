{TITLE}

<div class="wide_table_wrap"><table class="columned_table wide_table results_table autosized_table" itemprop="significantLinks">
	<thead>
		<tr>
			<th>{!NAME}</th>
			<th>{!AMOUNT}</th>
			<th>{!DATE_TIME}</th>
			{+START,IF,{$NOT,{$MOBILE}}}
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

					{+START,IF,{$MOBILE}}
						<p class="assocated_details">
							<span class="field_name">{!STATUS}:</span> {STATE*}
						</p>
					{+END}
				</td>
				<td>
					{$CURRENCY_SYMBOL}{AMOUNT*}
				</td>
				<td>
					{TIME*}
				</td>
				{+START,IF,{$NOT,{$MOBILE}}}
					<td>
						{STATE*}
					</td>
				{+END}
				<td>
					{+START,IF,{PAYABLE}}
						{TRANSACTION_BUTTON}
					{+END}
					{+START,IF,{$HAS_ACTUAL_PAGE_ACCESS,admin_invoices}}
						<ul class="horizontal_links horiz_field_sep">
							<li><a class="button_screen_item menu___generic_admin__delete" href="{$PAGE_LINK*,adminzone:admin_invoices:delete:{INVOICE_ID}}"><span>{!DELETE}: #{INVOICE_ID}</span></a></li>
							{+START,IF,{DELIVERABLE}}
								<li><a title="{!DELIVER}: #{INVOICE_ID}" href="{$PAGE_LINK*,adminzone:admin_invoices:deliver:{INVOICE_ID}}">{!DELIVER}</a></li>
							{+END}
						</ul>
					{+END}
				</td>
			</tr>
			{+START,IF_NON_EMPTY,{NOTE}}
				<tr class="{$GET,cycle}">
					<td colspan="5">
						{NOTE*}
					</td>
				</tr>
			{+END}
		{+END}
	</tbody>
</table></div>
