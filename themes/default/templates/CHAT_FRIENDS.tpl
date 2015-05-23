{+START,IF_NON_EMPTY,{FRIENDS}}
	<div class="wide_table_wrap"><table class="columned_table results_table wide_table autosized_table">
		<colgroup>
			<col class="chat_friends_column" />

			<col class="chat_name_column" />

			{+START,IF,{$NOT,{SIMPLER}}}
				<col class="chat_online_column" />
			{+END}

			{+START,IF,{$NOT,{SIMPLER}}}
				<col class="chat_choose_column" />
			{+END}
		</colgroup>

		<thead>
			<tr>
				<th></th>

				<th>
					{+START,IF,{$NOT,{SIMPLER}}}
						{!NAME}
					{+END}

					{+START,IF,{SIMPLER}}
						{!FRIEND}
					{+END}
				</th>

				{+START,IF,{$NOT,{SIMPLER}}}
					<th>
						<a target="_blank" title="{!ONLINE} {!LINK_NEW_WINDOW}" href="{ONLINE_URL*}">{!ONLINE}</a>
					</th>
				{+END}

				{+START,IF,{$NOT,{SIMPLER}}}
					<th>
						{!CHOOSE}
					</th>
				{+END}
			</tr>
		</thead>
		<tbody>
			{+START,LOOP,FRIENDS}
				<tr>
					<td>
						<img{+START,IF,{SIMPLER}} title="{ONLINE_TEXT*}"{+END} id="friend_img_{MEMBER_ID*}" alt="" src="{$IMG*,icons/24x24/menu/social/members}" />
					</td>

					<td>
						{+START,IF,{SIMPLER}}
							{+START,INCLUDE,MEMBER_TOOLTIP}SUBMITTER={MEMBER_ID}{+END}
						{+END}

						{+START,IF,{CAN_IM}}
							<a rel="friend" title="{$DISPLAYED_USERNAME*,{USERNAME}}: {!START_IM}" href="{$PAGE_LINK;*,_SEARCH:chat:enter_im={MEMBER_ID}}"{+START,IF,{$CONFIG_OPTION,sitewide_im}} onclick="if (typeof window.start_im=='undefined') return true; return start_im('{MEMBER_ID*}',true{$,{$?,{SIMPLER},true,false}});"{+END}>{$DISPLAYED_USERNAME*,{USERNAME}}</a>
						{+END}
						{+START,IF,{$NOT,{CAN_IM}}}
							{$DISPLAYED_USERNAME*,{USERNAME}}
						{+END}
					</td>

					{+START,IF,{$NOT,{SIMPLER}}}
						<td id="online_{MEMBER_ID*}">
							{ONLINE_TEXT*}
						</td>
					{+END}

					{+START,IF,{$NOT,{SIMPLER}}}
						<td>
							<label class="accessibility_hidden" for="select_{MEMBER_ID*}">{!CHOOSE}</label>
							<input type="checkbox" id="select_{MEMBER_ID*}" value="1" name="select_{MEMBER_ID*}" />
						</td>
					{+END}
				</tr>
			{+END}
		</tbody>
	</table></div>

	<script>
	// <![CDATA[
		{+START,LOOP,FRIENDS}
			{+START,IF,{$NEQ,{ONLINE_TEXT*},{!ACTIVE}}}
				document.getElementById('friend_img_{MEMBER_ID;^/}').className='friend_inactive';
			{+END}
		{+END}
	// ]]>
	</script>
{+END}

{+START,IF_EMPTY,{FRIENDS}}
	{+START,IF_EMPTY,{FRIENDS_ONLINE}{FRIENDS_OFFLINE}}
		<p class="nothing_here">{!NO_FRIEND_ENTRIES}</p>
	{+END}
	{+START,IF_NON_EMPTY,{FRIENDS_ONLINE}{FRIENDS_OFFLINE}}
		<p class="nothing_here">{!NOBODY_ONLINE}</p>
	{+END}
{+END}
