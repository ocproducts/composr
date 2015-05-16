{TITLE}

{+START,INCLUDE,HANDLE_CONFLICT_RESOLUTION}{+END}
{+START,IF_PASSED,WARNING_DETAILS}
	{WARNING_DETAILS}
{+END}

{+START,IF_NON_EMPTY,{TEXT}}
	{$PARAGRAPH,{TEXT}}
{+END}

{+START,IF,{$IN_STR,{FIELDS},required_star}}
	{+START,INCLUDE,FORM_SCREEN_ARE_REQUIRED}{+END}
{+END}

{+START,IF,{$MATCH_KEY_MATCH,cms:cms_downloads:ad}}
	<p>
		<strong>If you have already added an earlier version of this addon</strong> for a particular Composr version then please edit that addon rather than adding a new one. Only add new addons if they are truly new, or if this is a release for a different Composr version, or if you have made such changes that mean there is a strong reason that new users may still want to use the old version. This policy is necessary to keep the addon directory tidy and to allow automatic addon upgrade advice.
	</p>
	<p>
		If you are new to the community your addon will need to go through the validation process. Users with enough points to be of a higher rank won't require this validation process.
	</p>
	<p>
		Please make sure you give the download name <em>exactly</em> the same name as the addon name.
	</p>
{+END}

{$REQUIRE_JAVASCRIPT,checking}
{+START,IF_NON_PASSED,IFRAME_URL}
<form {+START,IF_PASSED_AND_TRUE,SUPPORT_AUTOSAVE}autocomplete="off" {+END}title="{!PRIMARY_PAGE_FORM}" id="main_form"{+START,IF_NON_PASSED_OR_FALSE,GET} method="post" action="{URL*}"{+START,IF,{$IN_STR,{FIELDS},"file"}} enctype="multipart/form-data"{+END}{+END}{+START,IF_PASSED_AND_TRUE,GET} method="get" action="{$URL_FOR_GET_FORM*,{URL}}"{+END}{+START,IF_PASSED,TARGET} target="{TARGET*}"{+END}{+START,IF_NON_PASSED,TARGET} target="_top"{+END}{+START,IF_PASSED_AND_TRUE,AUTOCOMPLETE} class="autocomplete"{+END}>
	{+START,IF_NON_PASSED_OR_FALSE,GET}{$INSERT_SPAMMER_BLACKHOLE}{+END}

	{+START,IF_PASSED_AND_TRUE,GET}{$HIDDENS_FOR_GET_FORM,{URL}}{+END}
{+END}
{+START,IF_PASSED,IFRAME_URL}
<form title="{!PRIMARY_PAGE_FORM}" id="main_form"{+START,IF_NON_PASSED_OR_FALSE,GET} method="post" action="{IFRAME_URL*}"{+START,IF,{$IN_STR,{FIELDS},"file"}} enctype="multipart/form-data"{+END}{+END}{+START,IF_PASSED_AND_TRUE,GET} method="get" action="{$URL_FOR_GET_FORM*,{IFRAME_URL}}"{+END} target="iframe_under"{+START,IF_PASSED_AND_TRUE,AUTOCOMPLETE} class="autocomplete"{+END}>
	{$INSERT_SPAMMER_BLACKHOLE}

	{+START,IF_PASSED_AND_TRUE,GET}{$HIDDENS_FOR_GET_FORM,{IFRAME_URL}}{+END}
{+END}

	{+START,IF_PASSED,SKIPPABLE}
		{+START,IF,{$JS_ON}}
			<div class="skip_step_button_wrap{+START,IF,{$IN_STR,{FIELDS},required_star}} skip_step_button_wrap_with_req_note{+END}">
				<div>
					<input type="hidden" id="{SKIPPABLE*}" name="{SKIPPABLE*}" value="0" />
					<input onclick="document.getElementById('{SKIPPABLE;}').value='1'; disable_button_just_clicked(this);" tabindex="151" class="buttons__skip button_screen_item" type="submit" value="{!SKIP}" />
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

		{+START,INCLUDE,FORM_STANDARD_END}{+END}
	</div>
</form>

{+START,IF_PASSED_AND_TRUE,SUPPORT_AUTOSAVE}
	{+START,IF,{$IS_A_COOKIE_LOGIN}}
		{$REQUIRE_JAVASCRIPT,posting}
		<script>// <![CDATA[
			add_event_listener_abstract(window,'load',function() {
				if (typeof init_form_saving!='undefined') init_form_saving('main_form');
			});
		//]]></script>
	{+END}
{+END}

{+START,IF_PASSED,IFRAME_URL}
	<a id="edit_space"></a>

	<div class="arrow_ruler">
		<form action="#" method="post">
			<div class="associated_link">
				<input onclick="var f=document.getElementById('main_form'); f.action=this.checked?non_iframe_url:iframe_url; f.elements['opens_below'].value=this.checked?'0':'1'; f.target=this.checked?'_blank':'iframe_under';" type="checkbox" name="will_open_new" id="will_open_new" /> <label for="will_open_new">{!CHOOSE_OPEN_NEW_WINDOW}</label>
			</div>
		</form>

		<img alt="" src="{$IMG*,arrow_ruler}" />
	</div>

	<iframe{$?,{$BROWSER_MATCHES,ie}, frameBorder="0" scrolling="no"} class="form_screen_iframe" title="{!EDIT}" name="iframe_under" id="iframe_under" src="{$BASE_URL*}/uploads/index.html">{!EDIT}</iframe>

	<script>// <![CDATA[
		if (typeof window.try_to_simplify_iframe_form!='undefined') try_to_simplify_iframe_form();
		var non_iframe_url='{URL;/}';
		var iframe_url='{IFRAME_URL;/}';
		window.setInterval(function() { resize_frame('iframe_under'); },1500);
	//]]></script>
{+END}
{+START,IF_NON_PASSED,IFRAME_URL}
	<script>// <![CDATA[
		if (typeof window.try_to_simplify_iframe_form!='undefined') try_to_simplify_iframe_form();
	//]]></script>
{+END}
