<div data-view="ToggleableTray">
	<h2 class="js-tray-header">
		<a class="toggleable_tray_button js-btn-tray-toggle" href="#!"><img alt="{!EXPAND}: {!MODULE_TRANS_NAME_subscriptions}" title="{!CONTRACT}" src="{$IMG*,1x/trays/contract}" srcset="{$IMG*,2x/trays/contract} 2x" /></a>
		<span class="js-btn-tray-toggle">{!MODULE_TRANS_NAME_subscriptions}</span>
	</h2>

	<div class="toggleable_tray js-tray-content" style="display: block" aria-expanded="true">
		<div class="wide_table_wrap"><table class="columned_table wide_table results_table autosized_table" itemprop="significantLinks">
			<thead>
				<tr>
					<th>
						{!TITLE}
					</th>

					<th>
						{!AMOUNT}
					</th>

					<th>
						{$TAX_LABEL}
					</th>

					<th>
						{!DATE}
					</th>

					{+START,IF,{$NOT,{$MOBILE}}}
						<th>
							{!PAYMENT_GATEWAY}
						</th>
					{+END}
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

							{+START,IF,{$MOBILE}}
								<p class="assocated_details">
									<span class="field_name">{!PAYMENT_GATEWAY}:</span> {PAYMENT_GATEWAY*}
								</p>
							{+END}
						</th>

						<td>
							{$CURRENCY_SYMBOL,{CURRENCY}}{TOTAL*}, {PER}
						</td>

						<td>
							{$CURRENCY_SYMBOL,{CURRENCY}}{TAX*}
						</td>

						<td>
							{START_TIME*}
						</td>

						{+START,IF,{$NOT,{$MOBILE}}}
							<td>
								{PAYMENT_GATEWAY*}
							</td>
						{+END}
					</tr>
				{+END}
			</tbody>
		</table></div>

		<p class="associated_link suggested_link"><a title="{!MODULE_TRANS_NAME_subscriptions}" href="{$PAGE_LINK*,_SEARCH:subscriptions:browse:{MEMBER_ID}}">{!MORE}</a></p>
	</div>
</div>
