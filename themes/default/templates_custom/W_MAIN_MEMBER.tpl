<tr class="{$CYCLE,results_table_zebra,zebra-0,zebra-1}">
	<td>
		{+START,IF_NON_EMPTY,{MEMBER_URL}}
			<a title="{NAME*} {!LINK_NEW_WINDOW}" target="_blank" href="{MEMBER_URL*}"><span class="{STYLE*}">{NAME*}</span></a>
		{+END}
		{+START,IF_EMPTY,{MEMBER_URL}}
			<span class="{STYLE*}">{NAME*}</span>
		{+END}

		{AUX*}
	</td>
	<td class="{STYLE*}">
		{HEALTH*}
	</td>
	<td>
		{+START,IF,{$GT,{ID},0}}
			<a title="{!W_INVENTORY}: {NAME*} {!LINK_NEW_WINDOW}" href="{$PAGE_LINK*,_SELF:_SELF:inventory:member={ID}}" target="_blank">{!W_INVENTORY}</a>
		{+END}
	</td>
</tr>
