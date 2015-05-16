<h2>{GROUP_NAME*}</h2>

<div class="wide_table_wrap"><table class="columned_table results_table wide_table spaced_table autosized_table">
	<thead>
		<tr>
			<th>{!USERNAME}</th>
			<th>{!DAYS_LAST_VISIT}</th>
			<th>{!ACTIONS}</th>
			<th>{!SKILLS}</th>
		</tr>
	</thead>
	<tbody>
		{+START,LOOP,ENTRIES}
			<tr class="{$CYCLE,results_table_zebra,zebra_0,zebra_1}">
				<td><strong>{USERNAME*}</strong></td>
				<td>{DAYS*}</td>
				<td>
					<a title="{!VIEW_PROFILE}: {USERNAME*}" href="{PROFILE_URL*}"><img src="{$IMG*,icons/24x24/menu/cms/author_set_own_profile}" alt="" /></a>
					{+START,IF,{$ADDON_INSTALLED,authors}}
						<a title="{!VIEW_AUTHOR}: {USERNAME*}" href="{AUTHOR_URL*}"><img src="{$IMG*,icons/24x24/menu/rich_content/authors}" alt="" /></a>
					{+END}
					{+START,IF,{$ADDON_INSTALLED,points}}
						{+START,IF_NON_EMPTY,{POINTS_URL}}
							<a title="{!VIEW_POINTS}: {USERNAME*}" href="{POINTS_URL*}"><img src="{$IMG*,icons/24x24/menu/social/points}" alt="" /></a>
						{+END}
					{+END}
					<a title="{!SEND_PM}: {USERNAME*}" href="{PM_URL*}"><img src="{$IMG*,icons/24x24/buttons/send}" alt="" /></a>
				</td>
				<td>{+START,IF_EMPTY,{SKILLS}}<em>{!NOT_SPECIFIED}</em>{+END}{SKILLS}</td>
			</tr>
		{+END}
	</tbody>
</table></div>

