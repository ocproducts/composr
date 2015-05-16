<tr>
	{+START,IF_NON_EMPTY,{SUBSCRIPTION}}
		<td rowspan="{ROWSPAN*}">{SUBSCRIPTION*}</td>
	{+END}
	<td>{MEMBER}</td>
	<td>{EXPIRY*}</td>
	<td><a title="{!_CANCEL_MANUAL_SUBSCRIPTION} #{ID*}" href="{CANCEL_URL*}">{!_CANCEL_MANUAL_SUBSCRIPTION}</a></td>
</tr>