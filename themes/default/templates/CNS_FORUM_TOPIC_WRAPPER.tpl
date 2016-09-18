<div class="wide_table_wrap"><table class="columned_table wide_table cns_topic_list">
	{+START,IF,{$NOT,{$MOBILE}}}
		<colgroup>
			{+START,IF,{$CONFIG_OPTION,is_on_topic_emoticons}}
				<col class="cns_forum_topic_wrapper_column_column1" />
			{+END}
			<col class="cns_forum_topic_wrapper_column_column2" />
			<col class="cns_forum_topic_wrapper_column_column3" />
			<col class="cns_forum_topic_wrapper_column_column4" />
			<col class="cns_forum_topic_wrapper_column_column5" />
			{+START,IF,{$OR,{$EQ,{$LANG},EN},{$LT,{$LENGTH,{!COUNT_POSTS}{!COUNT_VIEWS}},12}}}
				<col class="cns_forum_topic_wrapper_column_column6{$?,{$MATCH_KEY_MATCH,_WILD:members},_shorter}" />
			{+END}
			{+START,IF_NON_EMPTY,{MODERATOR_ACTIONS}}{+START,IF,{$NOT,{$_GET,overlay}}}
				<col class="cns_forum_topic_wrapper_column_column7" />
			{+END}{+END}
		</colgroup>
	{+END}

	<thead>
		<tr>
			{+START,IF,{$NOT,{$MOBILE}}}
				{+START,IF,{$CONFIG_OPTION,is_on_topic_emoticons}}
					<th class="cns_forum_box_left"></th>
				{+END}
			{+END}
			<th>{!TITLE}</th>
			<th>{!STARTER}{STARTER_TITLE*}</th>
			{+START,IF,{$NOT,{$MOBILE}}}
				<th>{!COUNT_POSTS}</th>
				{+START,IF,{$OR,{$EQ,{$LANG},EN},{$LT,{$LENGTH,{!COUNT_POSTS}{!COUNT_VIEWS}},12}}}
					<th>{!COUNT_VIEWS}</th>
				{+END}
			{+END}
			<th{+START,IF_EMPTY,{MODERATOR_ACTIONS}} class="cns_forum_box_right"{+END}>{!LAST_POST}</th>
			{+START,IF,{$NOT,{$MOBILE}}}
				{+START,IF_NON_EMPTY,{MODERATOR_ACTIONS}}{+START,IF_NON_EMPTY,{MODERATOR_ACTIONS}}{+START,IF,{$NOT,{$_GET,overlay}}}
					<th class="cns_forum_box_right">
						<a href="#" onclick="event.returnValue=false; mark_all_topics(event); return false;"><img src="{$IMG*,icons/14x14/cns_topic_modifiers/unvalidated}" srcset="{$IMG*,icons/28x28/cns_topic_modifiers/unvalidated} 2x" alt="{!TOGGLE_SELECTION}" title="{!TOGGLE_SELECTION}" /></a>
					</th>
				{+END}{+END}{+END}
			{+END}
		</tr>
	</thead>

	<tbody>
		{TOPICS}

		<tr class="cns_table_footer">
			{+START,IF,{$NOT,{$MOBILE}}}
				{+START,IF,{$CONFIG_OPTION,is_on_topic_emoticons}}
					<td class="cns_column1 cns_forum_box_bleft"></td>
				{+END}
			{+END}
			<td class="cns_column1{+START,IF,{$MOBILE}} cns_forum_box_bleft{+END}"></td>
			<td class="cns_column1"></td>
			{+START,IF,{$NOT,{$MOBILE}}}
				<td class="cns_column1"></td>
				{+START,IF,{$OR,{$EQ,{$LANG},EN},{$LT,{$LENGTH,{!COUNT_POSTS}{!COUNT_VIEWS}},12}}}
					<td class="cns_column1"></td>
				{+END}
			{+END}
			<td class="cns_column1{+START,IF,{$OR,{$MOBILE},{$IS_EMPTY,{MODERATOR_ACTIONS}}}} cns_forum_box_bright{+END}"></td>
			{+START,IF,{$NOT,{$MOBILE}}}
				{+START,IF_NON_EMPTY,{MODERATOR_ACTIONS}}{+START,IF,{$NOT,{$_GET,overlay}}}
					<td class="cns_column1 cns_forum_box_bright"></td>
				{+END}{+END}
			{+END}
		</tr>
	</tbody>
</table></div>

{+START,IF_NON_EMPTY,{PAGINATION}}
	<div class="float_surrounder pagination_spacing ajax_block_wrapper_links">
		{PAGINATION}
	</div>
{+END}

{+START,IF,{$NOT,{$WIDE_HIGH}}}
	{+START,IF_NON_EMPTY,{MODERATOR_ACTIONS}}
		{+START,IF,{$NOT,{$MOBILE}}}
			<div class="box cns_topic_actions"><div class="box_inner">
				<span class="field_name">
					<label for="fma_type">{!TOPIC_ACTIONS}: </label>
				</span>
				<form title="{!TOPIC_ACTIONS}" action="{$URL_FOR_GET_FORM*,{ACTION_URL}}" method="get" class="inline" autocomplete="off">
					{$HIDDENS_FOR_GET_FORM,{ACTION_URL}}

					<div class="inline">
						<select class="dropdown_actions" name="type" id="fma_type">
							<option value="browse">-</option>
							{MODERATOR_ACTIONS}
						</select><input onclick="if (add_form_marked_posts(this.form,'mark_')) { disable_button_just_clicked(this); return true; } window.fauxmodal_alert('{!NOTHING_SELECTED=;}'); return false;" class="button_micro buttons__proceed" type="submit" value="{!PROCEED}" />
					</div>
				</form>

				{+START,IF,{MAY_CHANGE_MAX}}
					<form title="{!PER_PAGE}" class="inline" action="{$URL_FOR_GET_FORM*,{$SELF_URL,0,1}}{+START,IF,{$EQ,{TYPE},pt}}#tab__pts{+END}" method="get" autocomplete="off">
						{$HIDDENS_FOR_GET_FORM,{$SELF_URL,0,1},forum_max}

						<div class="inline">
							<label for="forum_max">{!PER_PAGE}:</label>
							<select{+START,IF,{$JS_ON}} onchange="/*guarded*/this.form.submit();"{+END} name="forum_max" id="forum_max">
								<option value="10"{$?,{$EQ,{MAX},10}, selected="selected",}>10</option>
								<option value="20"{$?,{$EQ,{MAX},20}, selected="selected",}>20</option>
								<option value="30"{$?,{$EQ,{MAX},30}, selected="selected",}>30</option>
								<option value="50"{$?,{$EQ,{MAX},50}, selected="selected",}>50</option>
								<option value="100"{$?,{$EQ,{MAX},100}, selected="selected",}>100</option>
								<option value="300"{$?,{$EQ,{MAX},300}, selected="selected",}>300</option>
							</select><input onclick="if (add_form_marked_posts(this.form,'mark_')) { disable_button_just_clicked(this); return true; } window.fauxmodal_alert('{!NOTHING_SELECTED=;}'); return false;" class="button_micro buttons__proceed" type="submit" value="{!PROCEED}" />
						</div>
					</form>

					<form title="{!PER_PAGE}" class="inline" action="{$URL_FOR_GET_FORM*,{$SELF_URL,0,1}}{+START,IF,{$EQ,{TYPE},pt}}#tab__pts{+END}" method="get" autocomplete="off">
						{$HIDDENS_FOR_GET_FORM,{$SELF_URL,0,1},max}

						<div class="inline">
							<label for="order">{!SORT}:</label>
							<select{+START,IF,{$JS_ON}} onchange="/*guarded*/this.form.submit();"{+END} name="order" id="order">
								<option value="last_post"{$?,{$EQ,{ORDER},last_post}, selected="selected",}>{!FORUM_ORDER_BY_LAST_POST}</option>
								<option value="first_post"{$?,{$EQ,{ORDER},first_post}, selected="selected",}>{!FORUM_ORDER_BY_FIRST_POST}</option>
								<option value="title"{$?,{$EQ,{ORDER},title}, selected="selected",}>{!FORUM_ORDER_BY_TITLE}</option>
							</select>
							{+START,IF,{$NOT,{$JS_ON}}}<input onclick="disable_button_just_clicked(this);" class="button_micro buttons__sort" type="submit" value="{!SORT}" />{+END}
						</div>
					</form>
				{+END}
			</div></div>
		{+END}
	{+END}
{+END}
