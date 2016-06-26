<tr class="{$CYCLE,results_table_zebra,zebra_0,zebra_1}{+START,IF,{$AND,{$EQ,{LAST_POSTER_ID},{FIRST_POSTER_ID}},{$IS_STAFF},{$NOT,{CLOSED}}}} unclosed_ticket{+END}">
	<td>
		<a class="ticket_title" href="{URL*}">{+START,IF_EMPTY,{TITLE}}{!SUPPORT_TICKET}{+END}{TITLE*}</a>

		{+START,IF,{CLOSED}}
			<span class="closed_ticket">{!CLOSED}</span>
		{+END}

		{+START,IF,{$MOBILE}}
			<p><span class="field_name">{!COUNT_POSTS}:</span> {NUM_POSTS*}</p>
		{+END}

		{+START,IF_NON_EMPTY,{EXTRA_DETAILS}}
			<br />
			{EXTRA_DETAILS}
		{+END}
	</td>

	<td class="ticket_type">
		{TICKET_TYPE_NAME*}
	</td>

	{+START,IF,{$NOT,{$MOBILE}}}
		<td class="ticket_num_posts">
			{NUM_POSTS*}
		</td>
	{+END}

	<td>
		{+START,IF_NON_EMPTY,{FIRST_POSTER_PROFILE_URL}}
			<a class="ticket_first_poster" href="{FIRST_POSTER_PROFILE_URL*}">{FIRST_POSTER*}</a>
		{+END}
		{+START,IF_EMPTY,{FIRST_POSTER_PROFILE_URL}}
			{FIRST_POSTER*}
		{+END}
	</td>

	<td>
		<abbr class="ticket_age" title="{LAST_DATE*}">{$MAKE_RELATIVE_DATE*,{LAST_DATE_RAW}}</abbr>

		{+START,IF_NON_EMPTY,{LAST_POSTER_PROFILE_URL}}
			({!BY_SIMPLE_LOWER,<a class="ticket_last_poster" href="{LAST_POSTER_PROFILE_URL*}">{LAST_POSTER*}</a>})
		{+END}
		{+START,IF_EMPTY,{LAST_POSTER_PROFILE_URL}}
			({!BY_SIMPLE_LOWER,{LAST_POSTER*}})
		{+END}
	</td>

	<td>
		{+START,IF_NON_EMPTY,{ASSIGNED}}
			<ul class="horizontal_meta_details">
				{+START,LOOP,ASSIGNED}
					<li>{_loop_var*}</li>
				{+END}
			</ul>
		{+END}

		{+START,IF_EMPTY,{ASSIGNED}}
			<em>{!UNASSIGNED}</em>
		{+END}
	</td>

	{+START,IF_NON_EMPTY,{$GET,ticket_merge_into}}{+START,IF,{$HAS_PRIVILEGE,support_operator}}
		<td>
			<form title="{!MERGE_SUPPORT_TICKETS}" action="{$PAGE_LINK*,_SEARCH:tickets:merge:from={$GET,ticket_merge_into}:to={ID}}" method="post" autocomplete="off">
				{$INSERT_SPAMMER_BLACKHOLE}

				<input class="button_screen_item menu___generic_admin__merge" type="submit" title="{!MERGE_SUPPORT_TICKETS}" value="{!_MERGE}" />
			</form>
		</td>
	{+END}{+END}
</tr>

