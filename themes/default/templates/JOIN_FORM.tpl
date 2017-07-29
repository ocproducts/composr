{$REQUIRE_JAVASCRIPT,core_form_interfaces}
{$REQUIRE_JAVASCRIPT,core_cns}
{$REQUIRE_JAVASCRIPT,checking}
{$SET,form_name,form_{$RAND}}

<div data-tpl="joinForm" data-tpl-params="{+START,PARAMS_JSON,JS_FUNCTION_CALLS,SKIPPABLE,IS_JOIN_FORM,USERNAME_CHECK_SCRIPT,SNIPPET_SCRIPT,INVITES_ENABLED,ONE_PER_EMAIL_ADDRESS,USE_CAPTCHA}{_*}{+END}">
	{+START,IF_NON_EMPTY,{TEXT}}
		{$PARAGRAPH,{TEXT}}
	{+END}

	{+START,IF_NON_PASSED_OR_FALSE,SKIP_REQUIRED}
		{+START,IF,{$IN_STR,{FIELDS},required_star}}
			{+START,INCLUDE,FORM_SCREEN_ARE_REQUIRED}{+END}
		{+END}
	{+END}

	<form title="{!PRIMARY_PAGE_FORM}" class="{+START,IF_PASSED_AND_TRUE,MODSECURITY_WORKAROUND}js-submit-modesecurity-workaround{+END}" method="post" action="{URL*}" {+START,IF,{$IN_STR,{FIELDS},"file"}} enctype="multipart/form-data"{+END} id="{$GET*,form_name}" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		{+START,IF_PASSED_AND_TRUE,GET}{$HIDDENS_FOR_GET_FORM,{URL}}{+END}

		<div>
			{HIDDEN}

			<div class="wide_table_wrap"><table class="map_table form_table wide_table">
				{+START,IF,{$DESKTOP}}
					<colgroup>
						<col class="field_name_column" />
						<col class="field_input_column" />
					</colgroup>
				{+END}

				<tbody>
					{FIELDS}
				</tbody>
			</table></div>

			{+START,IF_NON_EMPTY,{SUBMIT_NAME}}
				{+START,INCLUDE,FORM_STANDARD_END}FORM_NAME={$GET,form_name}{+END}
			{+END}
		</div>
	</form>
</div>
