{$REQUIRE_JAVASCRIPT,core_permission_management}

<tr class="{$CYCLE,zebra,zebra-0,zebra-1}" data-tpl="permissionRow">
	<th>
		{PERMISSION*}
		{+START,IF_PASSED,DESCRIPTION}
			{+START,IF,{$DESKTOP}}
				<span class="inline-desktop">
					<img class="button-icon" width="24" height="24" src="{$IMG*,icons/help}" data-mouseover-activate-tooltip="['{DESCRIPTION;^*}','auto']" alt="{!HELP}" />
				</span>
			{+END}

			<span class="block-mobile">
				{DESCRIPTION}
			</span>
		{+END}
	</th>
	{CELLS}
	<td>
		<input title="{!SET_ALL_PERMISSIONS_ON_ROW}" class="button-micro js-click-input-toggle-value" type="button" value="{$?,{HAS},-,+}" data-click-eval="{CODE*}" />
	</td>
</tr>
