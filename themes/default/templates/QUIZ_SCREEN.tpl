{$REQUIRE_JAVASCRIPT,quizzes}

<div data-tpl="quizScreen" data-tpl-params="{+START,PARAMS_JSON,TIMEOUT}{_*}{+END}">
	{TITLE}

	{WARNING_DETAILS}

	{$REQUIRE_CSS,quizzes}

	{+START,IF_NON_EMPTY,{START_TEXT}}
		<div class="box box___quiz_screen"><div class="box_inner">
			<div itemprop="description">
				{$PARAGRAPH,{START_TEXT}}
			</div>
		</div></div>
	{+END}

	{$SET,bound_catalogue_entry,{$CATALOGUE_ENTRY_FOR,quiz,{ID}}}
	{+START,IF_NON_EMPTY,{$GET,bound_catalogue_entry}}{$CATALOGUE_ENTRY_ALL_FIELD_VALUES,{$GET,bound_catalogue_entry}}{+END}

	{+START,IF_NON_EMPTY,{TIMEOUT}}
		<p class="quiz_timer">
			{!TIME_REMAINING,<strong><span id="quiz_timer" style="display: none">{TIMEOUT*}</span><span id="quiz_timer_minutes_and_seconds"></span></strong>}
		</p>
	{+END}

	{$SET,no_required_stars,{ALL_REQUIRED}}
	{+START,IF,{$NOT,{ALL_REQUIRED}}}
		{+START,IF,{$IN_STR,{FIELDS},required_star}}
			{+START,INCLUDE,FORM_SCREEN_ARE_REQUIRED}{+END}
		{+END}
	{+END}

	<form title="{!SAVE}" id="quiz_form" class="quiz_form js-quiz-form js-submit-check-form" method="post" action="{URL*}" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		<div>
			<div class="wide_table_wrap"><table class="map_table form_table wide_table">
				{+START,IF,{$NOT,{$MOBILE}}}
					<colgroup>
						<col class="quiz_field_name_column" />
						<col class="quiz_field_input_column" />
					</colgroup>
				{+END}

				<tbody>
					{FIELDS}
				</tbody>
			</table></div>

			<p class="proceed_button">
				<input accesskey="u" class="button_screen buttons__proceed" type="submit" value="{!SUBMIT}" />
			</p>
		</div>
	</form>

	{$REVIEW_STATUS,quiz,{ID}}

	{+START,IF,{$CONFIG_OPTION,show_content_tagging}}{TAGS}{+END}

	{$,Load up the staff actions template to display staff actions uniformly (we relay our parameters to it)...}
	{+START,INCLUDE,STAFF_ACTIONS}
		1_URL={EDIT_URL*}
		1_TITLE={!EDIT}
		1_ACCESSKEY=q
		1_REL=edit
		1_ICON=menu/_generic_admin/edit_this
		{+START,IF,{$ADDON_INSTALLED,tickets}}
			2_URL={$PAGE_LINK*,_SEARCH:report_content:content_type=quiz:content_id={ID}:redirect={$SELF_URL&}}
			2_TITLE={!report_content:REPORT_THIS}
			2_ICON=buttons/report
			2_REL=report
		{+END}
	{+END}
</div>
