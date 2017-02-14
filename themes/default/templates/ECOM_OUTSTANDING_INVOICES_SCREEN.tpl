{TITLE}

<div class="wide_table_wrap"><table class="columned_table wide_table results_table autosized_table" itemprop="significantLinks">
	<thead>
		<tr>
			<th>{!TITLE}</th>
			<th>{!USERNAME}</th>
			<th>{!AMOUNT}</th>
			<th>{$TAX_LABEL}</th>
			<th>{!DATE_TIME}</th>
			<th>{!ACTIONS}</th>
		</tr>
	</thead>

	<tbody>
		{+START,LOOP,INVOICES}
			{$SET,cycle,{$CYCLE,results_table_zebra,zebra_0,zebra_1}}

			<tr class="{$GET,cycle} thick_border">
				<td>
					{INVOICE_TITLE*}
				</td>
				<td>
					<a href="{PROFILE_URL*}">{USERNAME*}</a>
				</td>
				<td>
					{$CURRENCY,{AMOUNT},{CURRENCY},{$?,{$CONFIG_OPTION,currency_auto},{$CURRENCY_USER},{$CURRENCY}}}
				</td>
				<td>
					{$CURRENCY,{TAX},{CURRENCY},{$?,{$CONFIG_OPTION,currency_auto},{$CURRENCY_USER},{$CURRENCY}}}
				</td>
				<td>
					{TIME*}
				</td>
				<td>
					<a title="{!DELETE}: #{ID}" href="{$PAGE_LINK*,_SELF:_SELF:delete:{ID}:from={FROM}}"><img src="{$IMG*,icons/14x14/delete}" srcset="{$IMG*,icons/28x28/delete} 2x" title="{!DELETE_INVOICE}" alt="{!DELETE_INVOICE}" /></a>
					{+START,IF,{$EQ,{STATE},paid}}
						<a title="{!MARK_AS_FULFILLED}: #{ID}" href="{$PAGE_LINK*,_SELF:_SELF:fulfill:{ID}}">{!MARK_AS_FULFILLED}</a>
					{+END}
				</td>
			</tr>
			{+START,IF_NON_EMPTY,{NOTE}}
				<tr class="{$GET,cycle}">
					<td colspan="6">
						<span class="field_name">{!NOTE}</span>: {NOTE*}
					</td>
				</tr>
			{+END}
		{+END}
	</tbody>
</table></div>
