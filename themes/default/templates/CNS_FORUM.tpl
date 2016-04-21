{+START,IF_PASSED,DESCRIPTION}{+START,IF_NON_EMPTY,{DESCRIPTION}}
	<div class="box box___cns_forum"><div class="box_inner">
		<div itemprop="description">
			{DESCRIPTION}
		</div>
	</div></div>
{+END}{+END}

{+START,IF_PASSED,ID}
	{+START,IF_NON_EMPTY,{$CATALOGUE_ENTRY_FOR,forum,{ID}}}{$CATALOGUE_ENTRY_ALL_FIELD_VALUES,{$CATALOGUE_ENTRY_FOR,forum,{ID}}}{+END}
{+END}

{+START,IF_NON_PASSED,ID}{+START,IF,{$MATCH_KEY_MATCH,_WILD:members}}
	<p>{!DESCRIPTION_PRIVATE_TOPICS}</p>
{+END}{+END}

{+START,IF_NON_EMPTY,{$TRIM,{FILTERS}}}
	<div class="box box___cns_forum"><div class="box_inner">
		<span class="cns_pt_category_filters">{!CATEGORIES}:</span> {FILTERS}
	</div></div>
{+END}

{+START,IF_PASSED,FILTERING}
	{FILTERING}
{+END}

{FORUM_GROUPINGS}

{+START,IF_EMPTY,{TOPIC_WRAPPER}{FORUM_GROUPINGS}}
	<p class="nothing_here">
		{!NO_ENTRIES,topic}
	</p>
{+END}

{+START,IF_NON_EMPTY,{TOPIC_WRAPPER}}{$,Does not show if no topics as that would double it up}
	{+START,IF_PASSED,ID}{$,Does not show on PT/virtual-forum view as those are less actiony places}
		{+START,IF,{$CONFIG_OPTION,enable_forum_dupe_buttons}}
			<div class="non_accessibility_redundancy">
				<div class="float_surrounder">
					<div class="buttons_group cns_buttons_screen">
						{+START,IF_PASSED,ID}
							{+START,INCLUDE,NOTIFICATION_BUTTONS}
								NOTIFICATIONS_TYPE=cns_topic
								NOTIFICATIONS_ID=forum:{ID}
								NOTIFICATIONS_PAGE_LINK=forum:topics:toggle_notifications_forum:forum%3A{ID}
							{+END}
						{+END}
						{BUTTONS}
					</div>
				</div>
			</div>
		{+END}
	{+END}
{+END}

{TOPIC_WRAPPER}

{+START,IF,{$NOT,{$WIDE_HIGH}}}
	<div class="float_surrounder">
		<div class="buttons_group cns_buttons_screen">
			{+START,IF_PASSED,ID}
				{+START,INCLUDE,NOTIFICATION_BUTTONS}
					NOTIFICATIONS_TYPE=cns_topic
					NOTIFICATIONS_ID=forum:{ID}
					NOTIFICATIONS_PAGE_LINK=forum:topics:toggle_notifications_forum:forum%3A{ID}
				{+END}
			{+END}
			{BUTTONS}
		</div>
	</div>

	{+START,IF_PASSED,ID}
		<div class="non_accessibility_redundancy">
			<nav class="breadcrumbs" itemprop="breadcrumb">
				<img class="breadcrumbs_img" src="{$IMG*,1x/breadcrumbs}" srcset="{$IMG*,2x/breadcrumbs} 2x" alt="&gt; " title="{!YOU_ARE_HERE}" />
				{BREADCRUMBS}
			</nav>
		</div>
	{+END}

	{$,Load up the staff actions template to display staff actions uniformly (we relay our parameters to it)...}
	{+START,IF_PASSED,ID}
		{$REVIEW_STATUS,forum,{ID}}

		{+START,IF,{$HAS_ACTUAL_PAGE_ACCESS,admin_cns_forums}}
			{+START,INCLUDE,STAFF_ACTIONS}
				1_URL={$PAGE_LINK*,_SEARCH:admin_cns_forums:add:parent_forum={ID}}
				1_TITLE={!ADD_FORUM}
				1_REL=add
				1_ICON=menu/_generic_admin/add_one_category
				2_URL={$PAGE_LINK*,_SEARCH:admin_cns_forums:_edit:{ID}}
				2_TITLE={!EDIT_FORUM}
				2_ACCESSKEY=q
				2_REL=edit
				2_ICON=menu/_generic_admin/edit_this_category
			{+END}
		{+END}
	{+END}
{+END}
