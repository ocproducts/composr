<section class="box box___block_side_users_online"><div class="box-inner">
	<h3>{!USERS_ONLINE}</h3>

	<p>{!FORUM_NUM_MEMBERS,{MEMBERS}}, {!NUM_GUESTS,{GUESTS*}}</p>

	{+START,IF_NON_EMPTY,{NEWEST}}
		{NEWEST}
	{+END}

	{+START,IF_NON_EMPTY,{BIRTHDAYS}}
		<div>
			<span class="field-name">{!BIRTHDAYS}:</span>
			<ul class="horizontal-links-comma">{+START,LOOP,BIRTHDAYS}<li><span class="birthday"><a {+START,IF_PASSED,COLOUR} class="{COLOUR}"{+END} href="{PROFILE_URL*}">{$DISPLAYED_USERNAME*,{USERNAME}}</a></span></li>{+END}</ul>
		</div>
	{+END}

	{+START,IF,{$AND,{$HAS_ACTUAL_PAGE_ACCESS,users_online},{$CNS}}}
		<ul class="horizontal-links associated-links-block-group">
			<li><a href="{$PAGE_LINK*,_SEARCH:users_online}" title="{!USERS_ONLINE}">{!DETAILS}</a></li>
		</ul>
	{+END}
</div></section>
