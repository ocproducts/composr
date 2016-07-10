<section class="box box___block_main_bottom_bar pale_box"><div class="box_inner">
	<h2>{!_STATISTICS}</h2>

	<div class="wide_table_wrap"><table class="map_table cns_stats_table wide_table">
		{+START,IF,{$NOT,{$MOBILE}}}
			<colgroup>
				<col class="cns_bottom_bar_left_column" />
				<col class="cns_bottom_bar_right_column" />
			</colgroup>
		{+END}

		<tbody>
			{+START,IF_NON_EMPTY,{USERS_ONLINE}}
				<tr>
					<th class="de_th cns_stats_usersonline_1">
						<p class="field_name">{!USERS_ONLINE}:</p>
						{+START,IF_NON_EMPTY,{USERS_ONLINE_URL}}<p class="associated_link associated_links_block_group"><a href="{USERS_ONLINE_URL*}" title="{!USERS_ONLINE}" rel="nofollow">{!DETAILS}</a></p>{+END}
					</th>

					<td class="cns_stats_usersonline_2">
						<p class="users_online cns_group_colours">{USERS_ONLINE}</p>

						{+START,IF_NON_EMPTY,{GROUPS}}
							<div class="usergroups cns_group_colours">
								<p>
									<span class="field_name">{!USERGROUPS}:&nbsp;</span>
								</p>
								<ul class="horizontal_links_comma">
									{+START,LOOP,GROUPS}
										<li><a class="{GCOLOUR*}" href="{$PAGE_LINK*,_SEARCH:groups:view:{GID}}">{GTITLE*}</a></li>
									{+END}
								</ul>
							</div>
						{+END}
					</td>
				</tr>
			{+END}

			<tr>
				<th class="de_th cns_stats_main_1">
					<span class="field_name">{!FORUM_STATISTICS}:</span>
				</th>

				<td class="cns_stats_main_2">
					<ul class="meta_details_list">
						<li>{!FORUM_NUM_TOPICS,{NUM_TOPICS*}}, {!FORUM_NUM_POSTS,{NUM_POSTS*}}, {!FORUM_NUM_MEMBERS,{NUM_MEMBERS*}}</li>
						<li>{!NEWEST_MEMBER,<a href="{NEWEST_MEMBER_PROFILE_URL*}">{$DISPLAYED_USERNAME*,{NEWEST_MEMBER_USERNAME}}</a>}</li>
					</ul>

					{+START,IF_NON_EMPTY,{BIRTHDAYS}}
						<span class="field_name">{!BIRTHDAYS}:</span>
						<ul class="horizontal_links_comma">{+START,LOOP,BIRTHDAYS}<li><span class="birthday"><a{+START,IF_PASSED,COLOUR} class="{COLOUR}"{+END} href="{BIRTHDAY_URL*}" title="{!CREATE_BIRTHDAY_TOPIC}: {$DISPLAYED_USERNAME*,{USERNAME}}">{$DISPLAYED_USERNAME*,{USERNAME}}</a>{+START,IF_PASSED,AGE} ({AGE*}){+END}</span></li>{+END}</ul>
					{+END}
				</td>
			</tr>
		</tbody>
	</table></div>
</div></section>
