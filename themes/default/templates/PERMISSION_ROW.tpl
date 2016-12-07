<tr class="{$CYCLE,zebra,zebra_0,zebra_1}">
	<th>
		{PERMISSION*}
		{+START,IF_PASSED,DESCRIPTION}<img class="button_icon" src="{$IMG*,icons/16x16/help}" srcset="{$IMG*,icons/32x32/help} 2x" data-mouseover-activate-tooltip="['{DESCRIPTION;^*}','auto']" alt="{!HELP}" />{+END}
	</th>
	{CELLS}
	<td>
		<input title="{!SET_ALL_PERMISSIONS_ON_ROW}" class="button_micro" type="button" value="{$?,{HAS},-,+}" onclick="{CODE*}; this.value=(this.value=='-')?'+':'-';" />
	</td>
</tr>
