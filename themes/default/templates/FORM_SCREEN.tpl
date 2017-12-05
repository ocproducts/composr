{$REQUIRE_JAVASCRIPT,checking}
{$REQUIRE_JAVASCRIPT,core_form_interfaces}

<div data-tpl="formScreen" data-tpl-params="{+START,PARAMS_JSON,URL,IFRAME_URL,SKIPPABLE}{_*}{+END}">
	{TITLE}

	{+START,INCLUDE,HANDLE_CONFLICT_RESOLUTION}{+END}
	{+START,IF_PASSED,WARNING_DETAILS}
		{WARNING_DETAILS}
	{+END}

	{+START,IF_NON_EMPTY,{TEXT}}
		<div class="form_text">{$PARAGRAPH,{TEXT}}</div>
	{+END}

	{+START,IF,{$IN_STR,{FIELDS},required_star}}
		{+START,INCLUDE,FORM_SCREEN_ARE_REQUIRED}{+END}
	{+END}

	{+START,IF_NON_PASSED,IFRAME_URL}
	<form title="{!PRIMARY_PAGE_FORM}" id="main_form"{+START,IF_NON_PASSED_OR_FALSE,GET} method="post" action="{URL*}"{+START,IF,{$IN_STR,{FIELDS},"file"}} enctype="multipart/form-data"{+END}{+END}{+START,IF_PASSED_AND_TRUE,GET} method="get" action="{$URL_FOR_GET_FORM*,{URL}}"{+END}{+START,IF_PASSED,TARGET} target="{TARGET*}"{+END}{+START,IF_NON_PASSED,TARGET} target="_top"{+END} autocomplete="off"{+START,IF_PASSED_AND_TRUE,MODSECURITY_WORKAROUND} data-submit-modsecurity-workaround="1"{+END}>
		{+START,IF_NON_PASSED_OR_FALSE,GET}{$INSERT_SPAMMER_BLACKHOLE}{+END}

		{+START,IF_PASSED_AND_TRUE,GET}{$HIDDENS_FOR_GET_FORM,{URL}}{+END}
	{+END}
	{+START,IF_PASSED,IFRAME_URL}
	<form title="{!PRIMARY_PAGE_FORM}" id="main_form"{+START,IF_NON_PASSED_OR_FALSE,GET} method="post" action="{IFRAME_URL*}"{+START,IF,{$IN_STR,{FIELDS},"file"}} enctype="multipart/form-data"{+END}{+END}{+START,IF_PASSED_AND_TRUE,GET} method="get" action="{$URL_FOR_GET_FORM*,{IFRAME_URL}}"{+END} target="iframe_under" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		{+START,IF_PASSED_AND_TRUE,GET}{$HIDDENS_FOR_GET_FORM,{IFRAME_URL}}{+END}
	{+END}

		{+START,IF_PASSED,SKIPPABLE}
			<div class="skip_step_button_wrap{+START,IF,{$IN_STR,{FIELDS},required_star}} skip_step_button_wrap_with_req_note{+END}">
				<div>
					<input type="hidden" id="{SKIPPABLE*}" name="{SKIPPABLE*}" value="0" />
					<input data-disable-on-click="1" tabindex="151" class="button_screen_item buttons--skip js-btn-skip-step" type="submit" value="{!SKIP}" />
				</div>
			</div>
		{+END}

		<div>
			{HIDDEN}

			{+START,IF_NON_EMPTY,{FIELDS}}
				<div class="wide_table_wrap"><table class="map_table form_table wide_table scrollable_inside">
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
			{+END}

			{+START,INCLUDE,FORM_STANDARD_END}FORM_NAME=main_form{+END}
		</div>
	</form>

	{+START,IF_PASSED,IFRAME_URL}
		<a id="edit_space"></a>

		<div class="arrow_ruler">
			<form action="#!" method="post" autocomplete="off">
				<div class="associated-link">
					<input type="checkbox" name="will_open_new" id="will_open_new" class="js-checkbox-will-open-new" />
					<label for="will_open_new">{!CHOOSE_OPEN_NEW_WINDOW}</label>
				</div>
			</form>

			<img alt="" src="{$IMG*,arrow_ruler}" />
		</div>

		<iframe {$?,{$BROWSER_MATCHES,ie}, frameBorder="0" scrolling="no"} class="form_screen_iframe" title="{!EDIT}" name="iframe_under" id="iframe_under" src="{$BASE_URL*}/uploads/index.html">{!EDIT}</iframe>
	{+END}
</div>
