<section class="box box___block_side_users_online"><div class="box_inner">
	<h3>{!USERS_ONLINE}</h3>

	<p>{CONTENT} <span class="associated_details">{!NUM_GUESTS,{GUESTS*}}</span></p>

	{+START,IF_NON_EMPTY,{NEWEST}}
		{NEWEST}
	{+END}

	{+START,IF_NON_EMPTY,{BIRTHDAYS}}
		<div>{BIRTHDAYS}</div>
	{+END}

	{+START,IF,{$AND,{$HAS_ACTUAL_PAGE_ACCESS,users_online},{$CNS}}}
		<ul class="horizontal_links associated_links_block_group">
			<li><a href="{$PAGE_LINK*,_SEARCH:users_online}" title="{!USERS_ONLINE}">{!DETAILS}</a></li>
		</ul>
	{+END}
</div></section>
