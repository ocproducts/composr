{TITLE}

<p>{!SUBSCRIPTIONS_SCREEN}</p>

{+START,IF_NON_EMPTY,{SUBSCRIPTIONS}}
	<div class="wide_table_wrap"><table class="columned_table wide_table results_table autosized_table responsive-table" itemprop="significantLinks">
		<thead>
			<tr>
				<th>
					{!TITLE}
				</th>

				<th>
					{!PRICE}
				</th>

				<th>
					{$TAX_LABEL}
				</th>

				<th>
					{!DATE}
				</th>

				{+START,IF,{$DESKTOP}}
					<th class="cell_desktop">
						{!PAYMENT_GATEWAY}
					</th>

					<th class="cell_desktop">
						{!RENEWAL_STATUS}
					</th>
				{+END}

				<th>
					{!ACTIONS}
				</th>
			</tr>
		</thead>

		<tbody>
			{+START,LOOP,SUBSCRIPTIONS}
				<tr>
					<th>
						{+START,IF_PASSED,USERGROUP_SUBSCRIPTION_DESCRIPTION}
							<span class="comcode_concept_inline" data-mouseover-activate-tooltip="['{USERGROUP_SUBSCRIPTION_DESCRIPTION;^*}','auto']">{ITEM_NAME*}</span>
						{+END}
						{+START,IF_NON_PASSED,USERGROUP_SUBSCRIPTION_DESCRIPTION}
							{ITEM_NAME*}
						{+END}

						<p class="assocated_details block_mobile">
							<span class="field-name">{!PAYMENT_GATEWAY}:</span> {PAYMENT_GATEWAY*}
						</p>
						<p class="assocated_details block_mobile">
							<span class="field-name">{!STATUS}:</span> {STATE*}
						</p>
					</th>

					<td>
						{$CURRENCY_SYMBOL,{CURRENCY}}{AMOUNT*}, {PER}
					</td>

					<td>
						{$CURRENCY_SYMBOL,{CURRENCY}}{TAX*}
					</td>

					<td>
						{START_TIME*}
						{+START,IF_NON_EMPTY,{EXPIRY_TIME}}
							&ndash; {EXPIRY_TIME*}
						{+END}
					</td>

					{+START,IF,{$DESKTOP}}
						<td class="cell_desktop">
							{PAYMENT_GATEWAY*}
						</td>

						<td class="cell_desktop">
							{STATE*}
						</td>
					{+END}

					<td class="subscriptions_cancel_button">
						{+START,IF_PASSED,CANCEL_BUTTON}
							{CANCEL_BUTTON}
						{+END}
						{+START,IF_NON_PASSED,CANCEL_BUTTON}
							<a data-cms-confirm-click="{!SUBSCRIPTION_CANCEL_WARNING_GENERAL*}" href="{$PAGE_LINK*,_SELF:_SELF:cancel:{SUBSCRIPTION_ID}}">{!SUBSCRIPTION_CANCEL}</a>
						{+END}
					</td>
				</tr>
			{+END}
		</tbody>
	</table></div>
{+END}

{+START,IF_EMPTY,{SUBSCRIPTIONS}}
	<p class="nothing_here">
		{!NO_ENTRIES}
	</p>
{+END}

<p class="buttons-group">
	<a class="button_screen buttons--proceed" rel="add" href="{$PAGE_LINK*,_SEARCH:purchase:type_filter={$PRODUCT_SUBSCRIPTION}}"><span>{!START_NEW_SUBSCRIPTION}</span></a>
</p>
