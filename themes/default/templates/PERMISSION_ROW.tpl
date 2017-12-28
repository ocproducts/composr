{$REQUIRE_JAVASCRIPT,core_permission_management}

<tr class="{$CYCLE,zebra,zebra_0,zebra_1}" data-tpl="permissionRow">
	<th>
		{PERMISSION*}
		{+START,IF_PASSED,DESCRIPTION}
			{+START,IF,{$DESKTOP}}
				<span class="inline_desktop">
					<img class="button_icon" src="{$IMG*,icons/16x16/help}" srcset="{$IMG*,icons/32x32/help} 2x" data-mouseover-activate-tooltip="['{DESCRIPTION;^*}','auto']" alt="{!HELP}" />
				</span>
			{+END}

			<span class="block_mobile">
				{DESCRIPTION}
			</span>
		{+END}
	</th>
	{CELLS}
	<td>
		<input title="{!SET_ALL_PERMISSIONS_ON_ROW}" class="button-micro js-click-input-toggle-value" type="button" value="{$?,{HAS},-,+}" data-click-eval="{CODE*}" />
	</td>
</tr>
