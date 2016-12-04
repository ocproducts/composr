{TITLE}

{+START,IF_PASSED,RESULTS}
	{+START,IF_EMPTY,{RESULTS}}
		<p class="nothing_here">{!NO_RESULTS_SEARCH}</p>
	{+END}
	{+START,IF_NON_EMPTY,{RESULTS}}
		<h2>{$?,{$IS_EMPTY,{SEARCH_TERM}},{!SEARCH_RESULTS_ARE_UNNAMED,{NUM_RESULTS*}{$?,{$EQ,{NUM_RESULTS},{$NUMBER_FORMAT,{$MAXIMUM_RESULT_COUNT_POINT}}},+}},{!SEARCH_RESULTS_ARE,{NUM_RESULTS*}{$?,{$EQ,{NUM_RESULTS},{$NUMBER_FORMAT,{$MAXIMUM_RESULT_COUNT_POINT}}},+},{SEARCH_TERM*}}}</h2>

		<div class="float_surrounder" itemscope="itemscope" itemtype="http://schema.org/SearchResultsPage">
			{RESULTS}
		</div>

		{+START,IF_NON_EMPTY,{PAGINATION}}
			<div class="float_surrounder pagination_spacing">
				{PAGINATION}
			</div>
		{+END}
	{+END}
{+END}

{+START,IF_PASSED,RESULTS}
<div class="box">
{+END}
	{+START,IF_PASSED,RESULTS}
		<h2 class="toggleable_tray_title">
			<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode);">{!SETTINGS}</a>
			{+START,IF_NON_EMPTY,{RESULTS}}
				<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode);"><img src="{$IMG*,1x/trays/expand2}" srcset="{$IMG*,2x/trays/expand2} 2x" alt="{!SHOW_SEARCH_FORM}" title="{!SHOW_SEARCH_FORM}" /></a>
			{+END}
		</h2>
	{+END}

	<div{+START,IF_PASSED,RESULTS}{+START,IF_NON_EMPTY,{RESULTS}} style="display: {$JS_ON,none,block}"{+END}{+END} id="search_form" class="toggleable_tray" aria-expanded="false">
		<p>
			{!SEARCH_HELP}
		</p>

		{$,Load up the staff actions template to display staff actions uniformly (we relay our parameters to it)...}
		{+START,IF,{$AND,{$SHOW_DOCS},{$HAS_PRIVILEGE,see_software_docs}}}
			{+START,INCLUDE,STAFF_ACTIONS}
				STAFF_ACTIONS_TITLE={!STAFF_ACTIONS}
				1_URL={$TUTORIAL_URL*,tut_search}
				1_TITLE={!HELP}
				1_REL=help
				1_ICON=menu/pages/help
			{+END}
		{+END}

		<form title="{!PRIMARY_PAGE_FORM}" action="{$URL_FOR_GET_FORM*,{URL}}" target="_self" method="get" class="main_search_form" autocomplete="off">
			{$HIDDENS_FOR_GET_FORM,{URL}}
			<input type="hidden" name="all_defaults" value="0" />

			<div class="wide_table_wrap"><table class="map_table form_table wide_table">
				{+START,IF,{$NOT,{$MOBILE}}}
					<colgroup>
						<col class="field_name_column" />
						<col class="field_input_column" />
						<col class="field_sup_column" />
					</colgroup>
				{+END}

				<tbody>
					<tr>
						<th class="form_table_field_name">{!SEARCH_FOR}</th>
						<td class="form_table_field_input" colspan="2">
							<div class="accessibility_hidden"><label for="search_content">{!SEARCH_FOR}</label></div>
							<div class="constrain_field">
								<input maxlength="255"{+START,IF,{$MOBILE}} autocorrect="off"{+END} autocomplete="off" onkeyup="update_ajax_search_list(this,event{+START,IF_PASSED,SEARCH_TYPE},'{SEARCH_TYPE;^*}'{+END});" onkeypress="if (enter_pressed(event)) this.form.submit();" class="search_content wide_field" type="search" size="{$?,{$MOBILE},30,48}" id="search_content" name="content" value="{+START,IF_PASSED,CONTENT}{CONTENT*}{+END}" />
							</div>

							{+START,IF,{HAS_TEMPLATE_SEARCH}}
								<p class="associated_details">{!MAY_LEAVE_BLANK_ADVANCED}</p>
							{+END}
						</td>
					</tr>
					<tr>
						<th class="form_table_field_name">{!OPTIONS}</th>
						<td class="form_table_field_input" colspan="2">
							{+START,IF,{$CONFIG_OPTION,enable_boolean_search}}
								{+START,IF,{HAS_FULLTEXT_SEARCH}}
								<input type="checkbox" id="boolean_search"{+START,IF,{BOOLEAN_SEARCH}} checked="checked"{+END} name="boolean_search" value="1" onclick="document.getElementById('boolean_options').style.display=this.checked?'block':'none'; trigger_resize();" /> <label for="boolean_search">{!BOOLEAN_SEARCH}</label>
								<div style="display: {$JS_ON,none,block}" class="boolean_options" id="boolean_options">
								{+END}
									{+START,IF,{$NOT,{HAS_FULLTEXT_SEARCH}}}
										<p>
											<input type="radio"{+START,IF,{AND}} checked="checked"{+END} id="conjunctive_operator_and" name="conjunctive_operator" value="AND" /><label for="conjunctive_operator_and">{!SEARCH_AND}</label>
											<input type="radio"{+START,IF,{$NOT,{AND}}} checked="checked"{+END} id="conjunctive_operator_or" name="conjunctive_operator" value="OR" /><label for="conjunctive_operator_or">{!SEARCH_OR}</label>
										</p>
									{+END}
									<p>{!BOOLEAN_HELP}</p>
								{+START,IF,{HAS_FULLTEXT_SEARCH}}
								</div>
								{+END}
							{+END}
							<p><input type="checkbox"{+START,IF,{ONLY_TITLES}} checked="checked"{+END} id="only_titles" name="only_titles" value="1" /> <label for="only_titles">{!ONLY_TITLES}</label></p>
						</td>
					</tr>
					<tr>
						<th class="form_table_field_name">{USER_LABEL*}</th>
						<td class="form_table_field_input" colspan="2">
							<div class="accessibility_hidden"><label for="search_author">{USER_LABEL*}</label></div>
							<div class="constrain_field">
								<span class="invisible_ref_point"></span><input{+START,IF,{$MOBILE}} autocorrect="off"{+END} autocomplete="off" maxlength="80" class="wide_field" onkeyup="update_ajax_author_list(this,event);" type="text" value="{AUTHOR*}" id="search_author" name="author" />
							</div>
						</td>
					</tr>
					{+START,IF_PASSED,DAYS_LABEL}
						<tr>
							<th class="form_table_field_name">{DAYS_LABEL*}</th>
							<td class="form_table_field_input" colspan="2">
								<div class="accessibility_hidden"><label for="search_days">{DAYS_LABEL*}</label></div>
								<select id="search_days" name="days">
									<option selected="selected" value="-1">{!NA}</option>
									<option{+START,IF,{$EQ,{DAYS},2}} selected="selected"{+END} value="2">{!SUBMIT_AGE_DAYS,2}</option>
									<option{+START,IF,{$EQ,{DAYS},5}} selected="selected"{+END} value="5">{!SUBMIT_AGE_DAYS,5}</option>
									<option{+START,IF,{$EQ,{DAYS},15}} selected="selected"{+END} value="15">{!SUBMIT_AGE_DAYS,15}</option>
									<option{+START,IF,{$EQ,{DAYS},30}} selected="selected"{+END} value="30">{!SUBMIT_AGE_DAYS,30}</option>
									<option{+START,IF,{$EQ,{DAYS},45}} selected="selected"{+END} value="45">{!SUBMIT_AGE_DAYS,45}</option>
									<option{+START,IF,{$EQ,{DAYS},60}} selected="selected"{+END} value="60">{!SUBMIT_AGE_DAYS,60}</option>
									<option{+START,IF,{$EQ,{DAYS},120}} selected="selected"{+END} value="120">{!SUBMIT_AGE_DAYS,120}</option>
									<option{+START,IF,{$EQ,{DAYS},240}} selected="selected"{+END} value="240">{!SUBMIT_AGE_DAYS,240}</option>
									<option{+START,IF,{$EQ,{DAYS},365}} selected="selected"{+END} value="365">{!SUBMIT_AGE_DAYS,365}</option>
								</select>
							</td>
						</tr>
					{+END}
					{+START,IF_PASSED,DATE_RANGE_LABEL}
						<tr>
							<th class="form_table_field_name">{DATE_RANGE_LABEL*}</th>
							<td class="form_table_field_input" colspan="2">
								<div class="accessibility_hidden"><label for="cutoff_from">{DATE_RANGE_LABEL*} {!FROM}</label></div>
								{+START,INCLUDE,FORM_SCREEN_INPUT_DATE}
									NAME=cutoff_from
									TYPE=date
									REQUIRED=0
									UNLIMITED=0
									DAY={CUTOFF_FROM_DAY}
									MONTH={CUTOFF_FROM_MONTH}
									YEAR={CUTOFF_FROM_YEAR}
									MIN_DATE_DAY=1
									MIN_DATE_MONTH=1
									MIN_DATE_YEAR=1970
									MAX_DATE_DAY=
									MAX_DATE_MONTH=
									MAX_DATE_YEAR=
								{+END}
								<div class="accessibility_hidden"><label for="cutoff_to">{DATE_RANGE_LABEL*} {!TO}</label></div>
								{+START,INCLUDE,FORM_SCREEN_INPUT_DATE}
									NAME=cutoff_to
									TYPE=date
									REQUIRED=0
									UNLIMITED=0
									DAY={CUTOFF_TO_DAY}
									MONTH={CUTOFF_TO_MONTH}
									YEAR={CUTOFF_TO_YEAR}
									MIN_DATE_DAY=1
									MIN_DATE_MONTH=1
									MIN_DATE_YEAR=1970
									MAX_DATE_DAY=
									MAX_DATE_MONTH=
									MAX_DATE_YEAR=
								{+END}
							</td>
						</tr>
					{+END}
					<tr>
						<th class="form_table_field_name">{!SORT}</th>
						<td class="form_table_field_input" colspan="2">
							<div class="accessibility_hidden"><label for="search_direction">{!DIRECTION}</label></div>
							<div class="accessibility_hidden"><label for="search_sort">{!SORT_BY}</label></div>
							<select class="search_sort" id="search_sort" name="sort">
								<option{+START,IF,{$EQ,{SORT},relevance}} selected="selected"{+END} value="relevance">{!RELEVANCE_SORT}</option>
								<option{+START,IF,{$EQ,{SORT},add_date}} selected="selected"{+END} value="add_date">{!DATE}</option>
								<option{+START,IF,{$EQ,{SORT},title}} selected="selected"{+END} value="title">{!TITLE}</option>
								{+START,IF,{CAN_ORDER_BY_RATING}}
									<option{+START,IF,{$EQ,{SORT},rating}} selected="selected"{+END} value="average_rating">{!RATING}</option>
									<option{+START,IF,{$EQ,{SORT},rating}} selected="selected"{+END} value="compound_rating">{!POPULARITY}</option>
								{+END}
								{+START,LOOP,EXTRA_SORT_FIELDS}
									<option{+START,IF,{$EQ,{SORT},{_loop_key*}}} selected="selected"{+END} value="{_loop_key*}">{_loop_var*}</option>
								{+END}
							</select>
							<select id="search_direction" name="direction">
								<option{+START,IF,{$EQ,{DIRECTION},ASC}} selected="selected"{+END} value="ASC">{!ASCENDING}</option>
								<option{+START,IF,{$EQ,{DIRECTION},DESC}} selected="selected"{+END} value="DESC">{!DESCENDING}</option>
							</select>
						</td>
					</tr>

					{SPECIALISATION}
				</tbody>
			</table></div>

			<p class="proceed_button">
				<input onclick="disable_button_just_clicked(this);" accesskey="u" class="button_screen buttons__search" type="submit" value="{!SEARCH_TITLE}" />
			</p>
		</form>
	</div>
{+START,IF_PASSED,RESULTS}
</div>
{+END}
