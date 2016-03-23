{TITLE}

<h2>{!DETAILS}</h2>

<div class="wide_table_wrap"><table class="map_table results_table wide_table">
	<colgroup>
		<col class="field_name_column" />
		<col class="field_value_column" />
	</colgroup>

	<tbody>
		{+START,IF_NON_EMPTY,{REAL_NAME}}
			<tr>
				<th>{!REALNAME}</th>
				<td>{REAL_NAME*}</td>
			</tr>
		{+END}
		{+START,IF_NON_EMPTY,{ROLE}}
			<tr>
				<th>{!ROLE}</th>
				<td>{ROLE*}</td>
			</tr>
		{+END}
		<tr>
			<th>{!USERNAME}</th>
			<td><a class="associated_link suggested" href="{PROFILE_URL*}">{USERNAME*}</a></td>
		</tr>
		{+START,IF_NON_EMPTY,{ADDRESS}}
			{+START,IF,{$CNS}}
				<tr>
					<th>{!cns:ADD_PRIVATE_TOPIC}</th>
					<td><span class="associated_link"><a href="{$PAGE_LINK*,_SEARCH:topics:new_pt:{MEMBER_ID}}">{!cns:ADD_PRIVATE_TOPIC}</a></span></td>
				</tr>
			{+END}
			{+START,IF,{$NOT,{$CNS}}}
				<tr>
					<th>{!EMAIL}</th>
					<td><span class="associated_link"><a href="{$MAILTO}{$OBFUSCATE,{ADDRESS}}">{!EMAIL}</a></span></td>
				</tr>
			{+END}
		{+END}
	</tbody>
</table></div>

<div class="buttons_group">
	{+START,IF,{$HAS_ACTUAL_PAGE_ACCESS,admin_staff}}
		<a class="button_screen buttons__edit" rel="edit" href="{$PAGE_LINK*,_SEARCH:admin_staff}"><span>{!EDIT}</span></a>
	{+END}

	<a class="button_screen buttons__all" href="{ALL_STAFF_URL*}"><span>{!VIEW_ALL_STAFF}</span></a>
</div>

