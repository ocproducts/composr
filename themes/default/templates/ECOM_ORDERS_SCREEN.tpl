{TITLE}

<div class="wide_table_wrap"><table class="columned_table wide_table results_table autosized_table" itemprop="significantLinks">
	<thead>
		<tr>
			<th>{!ECOM_ORDER}</th>
			<th>{!PRICE}</th>
			<th>{$TAX_LABEL}</th>
			<th>{!SHIPPING_COST}</th>
			<th>{!ORDERED_DATE}</th>
			{+START,IF,{$NOT,{$MOBILE}}}
				<th>{!STATUS}</th>
			{+END}
			<th>{!TRANSACTION}</th>
		</tr>
	</thead>

	<tbody>
		{+START,LOOP,ORDERS}
			{$SET,cycle,{$CYCLE,results_table_zebra,zebra_0,zebra_1}}

			<tr class="{$GET,cycle}{+START,IF,{$NEQ,{_loop_key},0}} thick_border{+END}">
				<td>
					{+START,IF_NON_EMPTY,{ORDER_DET_URL}}
						<strong><a href="{ORDER_DET_URL*}">{ORDER_TITLE*}</a></strong>
					{+END}
					{+START,IF_EMPTY,{ORDER_DET_URL}}
						<strong>{ORDER_TITLE*}</strong>
					{+END}

					{+START,IF,{$MOBILE}}
						<p class="assocated_details">
							<span class="field_name">{!STATUS}:</span> {STATUS*}
						</p>
					{+END}
				</td>
				<td>
					{$CURRENCY_SYMBOL,{CURRENCY}}{TOTAL_PRICE*}
				</td>
				<td>
					{$CURRENCY_SYMBOL,{CURRENCY}}{TOTAL_TAX*}
				</td>
				<td>
					{$CURRENCY_SYMBOL,{CURRENCY}}{TOTAL_SHIPPING_COST*}
				</td>
				<td>
					{DATE*}
				</td>
				{+START,IF,{$NOT,{$MOBILE}}}
					<td>
						{STATUS*}
					</td>
				{+END}
				<td>
					{TRANSACTION_LINKER}
				</td>
			</tr>
			{+START,IF_NON_EMPTY,{NOTE}}
				<tr>
					<td colspan="{$?,{$MOBILE},4,5}">
						{NOTE*}
					</td>
				</tr>
			{+END}
		{+END}
	</tbody>
</table></div>
