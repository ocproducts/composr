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

{$REQUIRE_JAVASCRIPT,checking}
{+START,IF_NON_PASSED,IFRAME_URL}
<form title="{!PRIMARY_PAGE_FORM}" id="main_form"{+START,IF_NON_PASSED_OR_FALSE,GET} method="post" action="{URL*}"{+START,IF,{$IN_STR,{FIELDS},"file"}} enctype="multipart/form-data"{+END}{+END}{+START,IF_PASSED_AND_TRUE,GET} method="get" action="{$URL_FOR_GET_FORM*,{URL}}"{+END}{+START,IF_PASSED,TARGET} target="{TARGET*}"{+END}{+START,IF_NON_PASSED,TARGET} target="_top"{+END} autocomplete="off"{+START,IF_PASSED_AND_TRUE,MODSECURITY_WORKAROUND} onsubmit="return modsecurity_workaround(this);"{+END}>
	{+START,IF_NON_PASSED_OR_FALSE,GET}{$INSERT_SPAMMER_BLACKHOLE}{+END}

	{+START,IF_PASSED_AND_TRUE,GET}{$HIDDENS_FOR_GET_FORM,{URL}}{+END}
{+END}
{+START,IF_PASSED,IFRAME_URL}
<form title="{!PRIMARY_PAGE_FORM}" id="main_form"{+START,IF_NON_PASSED_OR_FALSE,GET} method="post" action="{IFRAME_URL*}"{+START,IF,{$IN_STR,{FIELDS},"file"}} enctype="multipart/form-data"{+END}{+END}{+START,IF_PASSED_AND_TRUE,GET} method="get" action="{$URL_FOR_GET_FORM*,{IFRAME_URL}}"{+END} target="iframe_under" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	{+START,IF_PASSED_AND_TRUE,GET}{$HIDDENS_FOR_GET_FORM,{IFRAME_URL}}{+END}
{+END}

	{+START,IF_PASSED,SKIPPABLE}
		{+START,IF,{$JS_ON}}
			<div class="skip_step_button_wrap{+START,IF,{$IN_STR,{FIELDS},required_star}} skip_step_button_wrap_with_req_note{+END}">
				<div>
					<input type="hidden" id="{SKIPPABLE*}" name="{SKIPPABLE*}" value="0" />
					<input onclick="document.getElementById('{SKIPPABLE;*}').value='1'; disable_button_just_clicked(this);" tabindex="151" class="button_screen_item buttons__skip" type="submit" value="{!SKIP}" />
				</div>
			</div>
		{+END}
	{+END}

	<div>
		{HIDDEN}

		{+START,IF_NON_EMPTY,{FIELDS}}
			<div class="wide_table_wrap"><table class="map_table form_table wide_table scrollable_inside">
				{+START,IF,{$NOT,{$MOBILE}}}
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
		<form action="#" method="post" autocomplete="off">
			<div class="associated_link">
				<input type="checkbox" name="will_open_new" id="will_open_new" class="js-checkbox-will-open-new" />
				<label for="will_open_new">{!CHOOSE_OPEN_NEW_WINDOW}</label>
			</div>
		</form>

		<img alt="" src="{$IMG*,arrow_ruler}" />
	</div>

	<iframe{$?,{$BROWSER_MATCHES,ie}, frameBorder="0" scrolling="no"} class="form_screen_iframe" title="{!EDIT}" name="iframe_under" id="iframe_under" src="{$BASE_URL*}/uploads/index.html">{!EDIT}</iframe>
{+END}
<script type="application/json" data-tpl-core-form-interfaces="formScreen">{+START,PARAMS_JSON,URL,IFRAME_URL}{_/}{+END}</script>