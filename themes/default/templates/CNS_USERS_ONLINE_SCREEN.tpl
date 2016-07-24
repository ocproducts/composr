{TITLE}

<div class="wide_table_wrap"><table class="columned_table autosized_table wide_table results_table">
	<thead>
		<tr>
			<th>
				{!USERNAME}
			</th>
			<th>
				{!LAST_ACTIVITY}
			</th>
			{+START,IF,{$NOT,{$MOBILE}}}
				{+START,IF,{$HAS_PRIVILEGE,show_user_browsing}}
					<th>
						{!LOCATION}
					</th>
				{+END}
			{+END}
			{+START,IF,{$ADDON_INSTALLED,securitylogging}}
				{+START,IF,{$HAS_PRIVILEGE,see_ip}}
					<th>
						{!IP_ADDRESS}
					</th>
				{+END}
			{+END}
		</tr>
	</thead>
	<tbody>
		{+START,LOOP,ROWS}
			{+START,SET,location}
				{+START,SET,_location}
					{+START,IF_NON_EMPTY,{LOCATION}}
						{LOCATION}
					{+END}
					{+START,IF_EMPTY,{LOCATION}}
						<em>{!OTHER}</em>
					{+END}
				{+END}

				{+START,IF_EMPTY,{AT_URL}}
					{$GET,_location}
				{+END}
				{+START,IF_NON_EMPTY,{AT_URL}}
					<a href="{AT_URL*}">{$TRIM,{$GET,_location}}</a>
				{+END}
			{+END}

			<tr class="{$CYCLE,results_table_zebra,zebra_0,zebra_1}">
				<td>
					{MEMBER}
				</td>
				<td>
					{!MINUTES_AGO,{TIME*}}

					{+START,IF,{$MOBILE}}
						{+START,IF,{$HAS_PRIVILEGE,show_user_browsing}}
							<p class="associated_details">
								{$GET,location}
							</p>
						{+END}
					{+END}
				</td>
				{+START,IF,{$NOT,{$MOBILE}}}
					{+START,IF,{$HAS_PRIVILEGE,show_user_browsing}}
						<td>
							{$GET,location}
						</td>
					{+END}
				{+END}
				{+START,IF,{$ADDON_INSTALLED,securitylogging}}
					{+START,IF,{$HAS_PRIVILEGE,see_ip}}
						<td>
							<a href="{$PAGE_LINK*,adminzone:admin_lookup:browse:{IP&}}">{IP*}</a>
						</td>
					{+END}
				{+END}
			</tr>
		{+END}
	</tbody>
</table></div>

