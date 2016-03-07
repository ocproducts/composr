{TITLE}

<p>{!SUBSCRIPTIONS_SCREEN}</p>

{+START,IF_NON_EMPTY,{SUBSCRIPTIONS}}
	<div class="wide_table_wrap"><table class="columned_table wide_table results_table autosized_table" itemprop="significantLinks">
		<thead>
			<tr>
				<th>
					{!TITLE}
				</th>

				<th>
					{!COST}
				</th>

				<th>
					{!DATE}
				</th>

				{+START,IF,{$NOT,{$MOBILE}}}
					<th>
						{!PAYMENT_GATEWAY}
					</th>

					<th>
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
							<span class="comcode_concept_inline" onmouseover="if (typeof window.activate_tooltip!='undefined') activate_tooltip(this,event,'{USERGROUP_SUBSCRIPTION_DESCRIPTION;^*}','auto');">{ITEM_NAME*}</span>
						{+END}
						{+START,IF_NON_PASSED,USERGROUP_SUBSCRIPTION_DESCRIPTION}
							{ITEM_NAME*}
						{+END}

						{+START,IF,{$MOBILE}}
							<p class="assocated_details">
								<span class="field_name">{!PAYMENT_GATEWAY}:</span> {VIA*}
							</p>
							<p class="assocated_details">
								<span class="field_name">{!STATUS}:</span> {STATE*}
							</p>
						{+END}
					</th>

					<td>
						{$CURRENCY_SYMBOL}{AMOUNT*}, {PER}
					</td>

					<td>
						{START_TIME*}
						{+START,IF_NON_EMPTY,{EXPIRY_TIME}}
							&ndash; {EXPIRY_TIME*}
						{+END}
					</td>

					{+START,IF,{$NOT,{$MOBILE}}}
						<td>
							{VIA*}
						</td>

						<td>
							{STATE*}
						</td>
					{+END}

					<td class="subscriptions_cancel_button">
						{+START,IF_PASSED,CANCEL_BUTTON}
							{CANCEL_BUTTON}
						{+END}
						{+START,IF_NON_PASSED,CANCEL_BUTTON}
							<a onclick="var t=this; window.fauxmodal_confirm('{!SUBSCRIPTION_CANCEL_WARNING_GENERAL=;}',function(result) { if (result) { click_link(t); } }); return false;" href="{$PAGE_LINK*,_SELF:_SELF:cancel:{SUBSCRIPTION_ID}}">{!SUBSCRIPTION_CANCEL}</a>
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

<p class="buttons_group">
	<a class="button_screen buttons__proceed" rel="add" href="{$PAGE_LINK*,_SEARCH:purchase:type_filter={$PRODUCT_SUBSCRIPTION}}"><span>{!START_NEW_SUBSCRIPTION}</span></a>
</p>
