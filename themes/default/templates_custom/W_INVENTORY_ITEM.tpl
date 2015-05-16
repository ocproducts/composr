<tr>
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
			<span class="ocw_fadedttext">{!W_BRIBABLE}: {!NO}</span>
		{+END}
		{+START,IF,{BRIBABLE}}
			{!W_BRIBABLE}: {!YES}
		{+END}
		<br />
		{+START,IF,{$NOT,{HEALTHY}}}
			<span class="ocw_fadedttext">{!W_HEALTHY}: {!NO}</span>
		{+END}
		{+START,IF,{HEALTHY}}
			{!W_HEALTHY}: {!YES}
		{+END}
	</td>
</tr>

