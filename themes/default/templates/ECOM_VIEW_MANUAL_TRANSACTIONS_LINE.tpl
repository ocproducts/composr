<tr>
	{+START,IF_NON_EMPTY,{SUBSCRIPTION}}
		<td rowspan="{ROWSPAN*}">{SUBSCRIPTION*}</td>
	{+END}
	<td>{MEMBER}</td>
	<td>{EXPIRY*}</td>
	<td>
		{+START,IF_NON_EMPTY,{CANCEL_URL}}
			<a title="{!_CANCEL_MANUAL_SUBSCRIPTION} #{ID*}" href="{CANCEL_URL*}">{!_CANCEL_MANUAL_SUBSCRIPTION}</a>
		{+END}
		{+START,IF_EMPTY,{CANCEL_URL}}
			{!PAYMENT_STATE_cancelled}
		{+END}
	</td>
</tr>