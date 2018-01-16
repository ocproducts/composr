<th class="permission-header-cell">
	{+START,IF,{$EQ,{GROUP},+/-}}
		{GROUP*}
	{+END}
	{+START,IF,{$NEQ,{GROUP},+/-}}
		<img class="gd_text" data-gd-text="{}" src="{$BASE_URL*}/data/gd_text.php?trans_color={COLOR*}&amp;text={$ESCAPE,{GROUP},UL_ESCAPED}{$KEEP*}" title="{GROUP*}" alt="{GROUP*}" />
	{+END}
</th>
