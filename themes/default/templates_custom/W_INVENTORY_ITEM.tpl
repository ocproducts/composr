<tr class="{$CYCLE,results_table_zebra,zebra-0,zebra-1}">
	<td>
		{+START,IF_EMPTY,{PIC_URL}}
			{!NA_EM}
		{+END}
		{+START,IF_NON_EMPTY,{PIC_URL}}
			<img style="{WIDTH*}" alt="{ITEM_NAME*}" src="{PIC_URL*}" />
		{+END}
	</td>
	<td>
		<strong>{ITEM_NAME*}</strong><br />
		{DESCRIPTION*}
	</td>
	<td>
		{ITEM_COUNT*}
	</td>
	<td>
		{+START,IF,{$NOT,{BRIBABLE}}}
			<span class="buildr-fadedttext">{!W_BRIBABLE}: {!NO}</span>
		{+END}
		{+START,IF,{BRIBABLE}}
			{!W_BRIBABLE}: {!YES}
		{+END}
		<br />
		{+START,IF,{$NOT,{HEALTHY}}}
			<span class="buildr-fadedttext">{!W_HEALTHY}: {!NO}</span>
		{+END}
		{+START,IF,{HEALTHY}}
			{!W_HEALTHY}: {!YES}
		{+END}
	</td>
</tr>
