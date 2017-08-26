{TITLE}

<p>{!CLASSIFIEDS_MY_ADVERTS_TEXT}</p>

<table class="columned_table wide_table results_table autosized_table spaced_table">
	<thead>
		<tr>
			<th>{!TITLE}</th>
			<th>{!COUNT_VIEWS}</th>
			<th>{!ADDED}</th>
			<th>{!CLASSIFIED_EXPIRES_ON}</th>
			<th>{!CLASSIFIED_ACTIVE}</th>
		</tr>
	</thead>
	{+START,LOOP,ADS}
		{$SET,cycle,{$CYCLE,results_table_zebra,zebra_0,zebra_1}}

		<tr class="{$GET,cycle} thick_border">
			<td><a href="{URL*}">{AD_TITLE}</td>
			<td>{NUM_VIEWS*}</td>
			<td>{DATE*}</td>
			<td>{EXPIRES_DATE*}</td>
			<td>
				{+START,IF,{ACTIVE}}
					{+START,IF_NON_EMPTY,{TRANSACTION_DETAILS}}
						{!YES}:
						<a title="{!CLASSIFIEDS_PURCHASE_TO_RENEW} (#{ID*})" href="{PURCHASE_URL*}">{!CLASSIFIEDS_PURCHASE_TO_RENEW}</a>
					{+END}
					{+START,IF_EMPTY,{TRANSACTION_DETAILS}}
						{!CLASSIFIEDS_RECOMMENDED}:
						<a title="{!CLASSIFIEDS_PURCHASE_TO_BUY} (#{ID*})" href="{PURCHASE_URL*}">{!CLASSIFIEDS_PURCHASE_TO_BUY}</a>
					{+END}
				{+END}

				{+START,IF,{$NOT,{ACTIVE}}}
					{!NO}:
					<a title="{!CLASSIFIEDS_PURCHASE_TO_MAKE_ACTIVE} (#{ID*})" href="{PURCHASE_URL*}">{!CLASSIFIEDS_PURCHASE_TO_MAKE_ACTIVE}</a>
				{+END}

				{+START,IF,{$HAS_ZONE_ACCESS,adminzone}}
					<p>{!ADMIN_EXTEND}: <a title="{!ecommerce:MANUAL_TRANSACTION} (#{ID*})" href="{$PAGE_LINK*,adminzone:admin_ecommerce_logs:trigger:{ID}:redirect={$SELF_URL&}}">{!ecommerce:MANUAL_TRANSACTION}</a></p>
				{+END}
			</td>
		</tr>
		{+START,IF_NON_EMPTY,{TRANSACTION_DETAILS}}
			<tr class="{$GET,cycle}">
				<td colspan="5">
					{+START,LOOP,TRANSACTION_DETAILS}
						<p class="mini_indent">
							<span class="right">{T_STATUS*} ({$?,{$IS_EMPTY,{T_VIA}},{!ecommerce:MANUAL_TRANSACTION},{T_VIA*}})</span>
							<strong>{$DATE_AND_TIME*,0,1,0,{T_TIME}}</strong>, {T_ITEM_TITLE*} @ {T_AMOUNT*} {T_CURRENCY*}
						</p>
						{+START,IF_NON_EMPTY,{T_PENDING_REASON}{T_REASON}{T_MEMO}}
							<p class="standard_indent">
								<span class="field_name">{!DETAILS}:</span> {T_PENDING_REASON*}{T_REASON*}{T_MEMO*}
							</p>
						{+END}
					{+END}
				</td>
			</tr>
		{+END}
	{+END}
</table>

{+START,IF_NON_EMPTY,{PAGINATION}}
	<div class="float_surrounder">
		{PAGINATION}
	</div>
{+END}
