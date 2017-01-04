{TITLE}

{$SET,bound_catalogue_entry,{$CATALOGUE_ENTRY_FOR,wiki_page,{ID}}}

{$REQUIRE_CSS,cns}

<div class="wiki_screen">
	{+START,IF_NON_EMPTY,{DESCRIPTION}}
		{+START,IF,{$NOT,{HIDE_POSTS}}}
			<div class="pe_wiki_page_description" itemprop="description">
				<div class="box box___wiki_page_screen"><div class="box_inner">
					<div>{$,To disassociated headers}
						{DESCRIPTION}
					</div>
				</div></div>

				{+START,IF_NON_EMPTY,{$GET,bound_catalogue_entry}}{$CATALOGUE_ENTRY_ALL_FIELD_VALUES,{$GET,bound_catalogue_entry}}{+END}
			</div>
		{+END}
		{+START,IF,{HIDE_POSTS}}
			<div class="pe_wiki_page_description">
				{DESCRIPTION}
			</div>

			{+START,IF_NON_EMPTY,{$GET,bound_catalogue_entry}}{$CATALOGUE_ENTRY_ALL_FIELD_VALUES,{$GET,bound_catalogue_entry}}{+END}

			<hr class="spaced_rule" />
		{+END}
	{+END}

	{+START,IF_EMPTY,{CHILDREN}}
		<p class="nothing_here">{!NO_CHILDREN}</p>
	{+END}
	{+START,IF_NON_EMPTY,{CHILDREN}}
		<div class="wiki_page_children">
			<p class="lonely_label">{!CHILD_PAGES}:</p>
			<ul itemprop="significantLinks" class="spaced_list">
				{+START,LOOP,CHILDREN}
					<li>
						<a title="{CHILD*}: {!WIKI_PAGES}" href="{URL*}">{CHILD*}</a>
						{+START,IF,{$OR,{$GT,{MY_CHILD_POSTS},0},{$GT,{MY_CHILD_CHILDREN},0},{$IS_NON_EMPTY,{BODY_CONTENT}}}}
							<br />
							{+START,IF_PASSED,BODY_CONTENT}{!BODY_CONTENT}, {+END}
							{!POST_PLU,{MY_CHILD_POSTS*}},
							{!CHILD_PLU,{MY_CHILD_CHILDREN*}}
						{+END}
						{+START,IF,{$NOR,{$GT,{MY_CHILD_POSTS},0},{$GT,{MY_CHILD_CHILDREN},0},{$IS_NON_EMPTY,{BODY_CONTENT}}}}
							{+START,IF,{HIDE_POSTS}}
								{!EMPTY}
							{+END}
						{+END}
					</li>
				{+END}
			</ul>
		</div>
	{+END}

	{+START,IF,{$OR,{$IS_NON_EMPTY,{POSTS}},{$NOT,{HIDE_POSTS}}}}
		{+START,IF,{HIDE_POSTS}}
			<div>
				<p class="toggleable_tray_title">
					<a class="toggleable_tray_button" title="{!DISCUSSION}: {!EXPAND}/{!CONTRACT}" href="#" onclick="return toggleable_tray('hidden_posts');"><img alt="{!EXPAND}: {!DISCUSSION}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand}" srcset="{$IMG*,2x/trays/expand} 2x" /></a>
					<a class="toggleable_tray_button" title="{!DISCUSSION}: {!EXPAND}/{!CONTRACT}" href="#" onclick="return toggleable_tray('hidden_posts');">{!DISCUSSION}</a> ({!POST_PLU,{NUM_POSTS*}})
				</p>
				<div class="toggleable_tray" id="hidden_posts" style="display: {$JS_ON,none,block}" aria-expanded="false">
		{+END}

		{+START,IF_EMPTY,{POSTS}}
			<p class="nothing_here">{!NO_POSTS}</p>
		{+END}
		{+START,IF_NON_EMPTY,{POSTS}}
			<div class="wide_table_wrap"><div class="map_table results_table wide_table cns_topic wiki_table">
				<div>
					{POSTS}
				</div>
			</div></div>
		{+END}

		{+START,IF,{HIDE_POSTS}}
				</div>
			</div>
		{+END}
	{+END}

	<div class="buttons_group">
		{+START,INCLUDE,NOTIFICATION_BUTTONS}
			NOTIFICATIONS_TYPE=wiki
			NOTIFICATIONS_ID={ID}
		{+END}

		{BUTTONS}

		{+START,IF_NON_EMPTY,{POSTS}}
			{+START,IF,{$AND,{$JS_ON},{STAFF_ACCESS}}}
				<form class="inline" title="{!MERGE_WIKI_POSTS}" action="{$PAGE_LINK*,_SEARCH:wiki:mg:{ID},1}" method="post" autocomplete="off">
					{$INSERT_SPAMMER_BLACKHOLE}

					<div class="inline">
						<input id="wiki_merge_button" style="display: none" onclick="if (add_form_marked_posts(this.form,'mark_')) { disable_button_just_clicked(this); return true; } window.fauxmodal_alert('{!NOTHING_SELECTED=;}'); return false;" class="menu___generic_admin__merge button_screen button_faded" type="submit" value="{!_MERGE_WIKI_POSTS}" />
					</div>
				</form>
			{+END}
		{+END}
	</div>

	{$REVIEW_STATUS,wiki_page,{ID}}

	{+START,IF,{$CONFIG_OPTION,show_content_tagging}}{TAGS}{+END}

	{+START,IF,{$CONFIG_OPTION,show_screen_actions}}{$BLOCK,failsafe=1,block=main_screen_actions,title={$METADATA,title}}{+END}
</div>
