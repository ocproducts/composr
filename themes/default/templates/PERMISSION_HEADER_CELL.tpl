<th class="permission-header-cell">
	{+START,IF,{$EQ,{GROUP},+/-}}
		{GROUP*}
	{+END}
	{+START,IF,{$NEQ,{GROUP},+/-}}
		<img class="gd-text" data-gd-text="{}" src="{$FIND_SCRIPT_NOHTTP*,gd_text}?trans_color={COLOR*}&amp;text={$ESCAPE,{GROUP},UL_ESCAPED}{$KEEP*}" title="{GROUP*}" alt="{GROUP*}" />
	{+END}
</th>
