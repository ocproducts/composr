{TITLE}

{WARNING_DETAILS}

{$SET,topic_title,{_TITLE}}

<div class="cns_topic_{THREADED*}">
	{+START,IF,{$CONFIG_OPTION,enable_forum_dupe_buttons}}
		<div class="non_accessibility_redundancy">
			<div class="float_surrounder">
				<div class="buttons_group cns_buttons_screen">
					{+START,INCLUDE,NOTIFICATION_BUTTONS}
						NOTIFICATIONS_TYPE=cns_topic
						NOTIFICATIONS_ID={ID}
						NOTIFICATIONS_PAGE_LINK=forum:topics:toggle_notifications_topic:{ID}
					{+END}
					{BUTTON_SCREENS}
				</div>
			</div>
		</div>
	{+END}

	{POLL}

	{$SET,bound_catalogue_entry,{$CATALOGUE_ENTRY_FOR,topic,{ID}}}
	{+START,IF_NON_EMPTY,{$GET,bound_catalogue_entry}}{$CATALOGUE_ENTRY_ALL_FIELD_VALUES,{$GET,bound_catalogue_entry}}{+END}

	{+START,IF,{$CONFIG_OPTION,enable_forum_dupe_buttons}}
		{+START,IF_NON_EMPTY,{PAGINATION}}
			<div class="non_accessibility_redundancy">
				<div class="pagination_spacing float_surrounder">
					{$REPLACE, id="blp_, id="blp2_,{$REPLACE, for="blp_, for="blp2_,{$REPLACE, id="r_, id="r2_,{$REPLACE, for="r_, for="r2_,{PAGINATION}}}}}
				</div>
			</div>
		{+END}
	{+END}

	{+START,IF,{THREADED}}
		<div class="comments_wrapper">
			<div class="boxless_space">
				{POSTS}
			</div>
		</div>

		{+START,IF_PASSED,SERIALIZED_OPTIONS}{+START,IF_PASSED,HASH}
			<script>// <![CDATA[
				window.comments_serialized_options='{SERIALIZED_OPTIONS;/}';
				window.comments_hash='{HASH;/}';
			//]]></script>
		{+END}{+END}
	{+END}
	{+START,IF,{$NOT,{THREADED}}}
		{+START,IF_NON_EMPTY,{POSTS}}
			<div class="wide_table_wrap"><div class="wide_table cns_topic autosized_table">
				<div>
					{POSTS}
				</div>
			</div></div>
		{+END}
	{+END}

	{+START,IF_NON_EMPTY,{ID}}
		<div class="box box___cns_topic_screen"><div class="box_inner">
			{+START,IF_NON_EMPTY,{MEMBERS_VIEWING}}
				{+START,IF,{$NEQ,{NUM_MEMBERS},0}}
					{!MEMBERS_VIEWING,{NUM_GUESTS*},{NUM_MEMBERS*},{MEMBERS_VIEWING}}
				{+END}
				{+START,IF,{$EQ,{NUM_MEMBERS},0}}
					{!_MEMBERS_VIEWING,{NUM_GUESTS*},{NUM_MEMBERS*},{MEMBERS_VIEWING}}
				{+END}
			{+END}
			{+START,IF_EMPTY,{MEMBERS_VIEWING}}
				{!TOO_MANY_USERS_ONLINE}
			{+END}
		</div></div>
	{+END}
	{+START,IF_EMPTY,{POSTS}}
		<p class="nothing_here">
			{!NO_ENTRIES}
		</p>
	{+END}

	{+START,IF,{$OR,{$IS_NON_EMPTY,{MODERATOR_ACTIONS}},{$AND,{$NOT,{$MOBILE}},{$IS_NON_EMPTY,{MARKED_POST_ACTIONS}}},{MAY_CHANGE_MAX}}}
		<div class="box cns_topic_control_functions"><div class="box_inner">
			{+START,IF,{$NOT,{$MOBILE}}}<span class="field_name">{!CONTROL_FUNCTIONS}:</span>{+END}

			{+START,IF_NON_EMPTY,{MODERATOR_ACTIONS}}
				<form title="{!TOPIC_ACTIONS}" action="{$URL_FOR_GET_FORM*,{ACTION_URL}}" method="get" class="inline horiz_field_sep_rightward">
					{$HIDDENS_FOR_GET_FORM,{ACTION_URL}}

					<div class="inline">
						<label for="tma_type" class="accessibility_hidden">{!TOPIC_ACTIONS}:</label>
						<select class="dropdown_actions" id="tma_type" name="type">
							<option value="browse">-</option>
							{MODERATOR_ACTIONS}
						</select><input class="buttons__proceed button_micro" type="submit" onclick="if (document.getElementById('tma_type').selectedIndex!=-1) { disable_button_just_clicked(this); return true; }  return false;" value="{!PROCEED}" />
					</div>
				</form>
			{+END}

			{+START,IF,{$NOT,{$MOBILE}}}
				{+START,IF_NON_EMPTY,{MARKED_POST_ACTIONS}}
					{+START,IF,{$JS_ON}}
						<form title="{!MARKED_POST_ACTIONS}" action="{$URL_FOR_GET_FORM*,{ACTION_URL}}" method="get" class="inline horiz_field_sep_rightward">
							{$HIDDENS_FOR_GET_FORM,{ACTION_URL}}

							<div class="inline horiz_field_sep_rightward">
								<label for="mpa_type">{!_MARKED_POST_ACTIONS}:</label>
								<select id="mpa_type" name="type">
									{+START,IF,{$GT,{$SUBSTR_COUNT,{MARKED_POST_ACTIONS},<option},1}}
										<option value="browse">-</option>
									{+END}
									{MARKED_POST_ACTIONS}
								</select><input class="buttons__proceed button_micro" type="submit" onclick="if (!add_form_marked_posts(this.form,'mark_')) { window.fauxmodal_alert('{!NOTHING_SELECTED=;}'); return false; } if (document.getElementById('mpa_type').selectedIndex!=-1) { disable_button_just_clicked(this); return true; } return false;" value="{!PROCEED}" />
							</div>
						</form>
					{+END}
				{+END}
			{+END}

			{+START,IF,{THREADED}}
				<form class="inline" action="{$SELF_URL*}" method="post">
					{$INSERT_SPAMMER_BLACKHOLE}

					<div class="inline">
						<label for="comments_sort">{!SORT}:</label>
						<select id="comments_sort" name="comments_sort">
							<option{+START,IF,{$EQ,{$_POST,comments_sort,oldest},relevance}} selected="selected"{+END} value="relevance">{!RELEVANCE}</option>
							<option{+START,IF,{$EQ,{$_POST,comments_sort,oldest},newest}} selected="selected"{+END} value="newest">{!NEWEST_FIRST}</option>
							<option{+START,IF,{$EQ,{$_POST,comments_sort,oldest},oldest}} selected="selected"{+END} value="oldest">{!OLDEST_FIRST}</option>
							<option{+START,IF,{$EQ,{$_POST,comments_sort,oldest},average_rating}} selected="selected"{+END} value="average_rating">{!RATING}</option>
							<option{+START,IF,{$EQ,{$_POST,comments_sort,oldest},compound_rating}} selected="selected"{+END} value="compound_rating">{!POPULARITY}</option>
						</select>
						<input type="submit" value="{!SORT}" class="buttons__sort button_micro" />
					</div>
				</form>
			{+END}
		</div></div>
	{+END}

	{+START,IF_NON_EMPTY,{PAGINATION}}
		<div class="float_surrounder pagination_spacing">
			{PAGINATION}
		</div>
	{+END}

	{+START,IF_NON_EMPTY,{POSTS}}
		<div class="float_surrounder">
			<div class="buttons_group cns_buttons_screen">
				{+START,INCLUDE,NOTIFICATION_BUTTONS}
					NOTIFICATIONS_TYPE=cns_topic
					NOTIFICATIONS_ID={ID}
					NOTIFICATIONS_PAGE_LINK=forum:topics:toggle_notifications_topic:{ID}
				{+END}
				{BUTTON_SCREENS}
			</div>

			{+START,IF,{$CONFIG_OPTION,enable_forum_dupe_buttons}}
				<div class="non_accessibility_redundancy left"><nav class="breadcrumbs" itemprop="breadcrumb">
					<p class="breadcrumbs">
						<img class="breadcrumbs_img" src="{$IMG*,1x/breadcrumbs}" srcset="{$IMG*,2x/breadcrumbs} 2x" alt="&gt; " title="{!YOU_ARE_HERE}" />
						{BREADCRUMBS}
					</p>
				</nav></div>
			{+END}
		</div>
	{+END}

	<div class="cns_quick_reply">
		{QUICK_REPLY}

		{+START,IF_EMPTY,{QUICK_REPLY}}{+START,IF,{$EQ,{LAST_POSTER},{$MEMBER}}}{+START,IF,{$NOT,{$IS_GUEST}}}{+START,IF,{$NOT,{MAY_DOUBLE_POST}}}
			<div class="box box__members_viewing"><div class="box_inner">
				{!NO_DOUBLE_POST}
			</div></div>
		{+END}{+END}{+END}{+END}
	</div>

	{$REVIEW_STATUS,topic,{ID}}

	{+START,IF,{$CONFIG_OPTION,show_screen_actions}}{+START,IF_PASSED,_TITLE}{$BLOCK,failsafe=1,block=main_screen_actions,title={_TITLE}}{+END}{+END}
</div>

