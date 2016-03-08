{+START,IF_PASSED_AND_TRUE,PREVIEW}{+START,IF,{$JS_ON}}{+START,IF,{$CONFIG_OPTION,enable_previews}}
	{+START,IF_NON_PASSED_OR_FALSE,SKIP_WEBSTANDARDS}{+START,IF,{$OR,{$CONFIG_OPTION,enable_markup_webstandards},{$CONFIG_OPTION,enable_spell_check},{$AND,{$HAS_PRIVILEGE,perform_keyword_check},{$CONFIG_OPTION,enable_keyword_density_check}}}}
		<div class="preview_checking_box">
			<section class="box box___form_standard_end"><div class="box_inner">
				<h3>{!PERFORM_CHECKS_ON_PREVIEW}</h3>

				{+START,IF,{$CONFIG_OPTION,enable_markup_webstandards}}
					<p>
						<span class="field_name">{!WEBSTANDARDS}:</span>
						<input title="{!DESCRIPTION_WEBSTANDARDS_ON_PREVIEW_0}"{+START,IF,{$NOT,{$HAS_PRIVILEGE,perform_webstandards_check_by_default}}} checked="checked"{+END} type="radio" name="perform_webstandards_check" value="0" id="perform_webstandards_check_no" /><label for="perform_webstandards_check_no">{!NO}</label>
						<input title="{!DESCRIPTION_WEBSTANDARDS_ON_PREVIEW_1}"{+START,IF,{$HAS_PRIVILEGE,perform_webstandards_check_by_default}} checked="checked"{+END} type="radio" name="perform_webstandards_check" value="1" id="perform_webstandards_check_yes" /><label for="perform_webstandards_check_yes">{!YES}</label>
						<input title="{!DESCRIPTION_WEBSTANDARDS_ON_PREVIEW_2}" type="radio" name="perform_webstandards_check" value="2" id="perform_webstandards_check_more" /><label for="perform_webstandards_check_more">{!MANUAL_CHECKS_TOO}</label>
					</p>
				{+END}
				{+START,IF,{$CONFIG_OPTION,enable_spell_check}}
					<p>
						<label for="perform_spellcheck"><span class="field_name">{!SPELLCHECK}:</span> <input title="{$STRIP_TAGS,{!SPELLCHECK}}" type="checkbox" checked="checked" name="perform_spellcheck" value="1" id="perform_spellcheck" /></label>
					</p>
				{+END}
				{+START,IF,{$CONFIG_OPTION,enable_keyword_density_check}}{+START,IF,{$HAS_PRIVILEGE,perform_keyword_check}}
					<p>
						<label for="perform_keywordcheck"><span class="field_name">{!KEYWORDCHECK}:</span> <input title="{$STRIP_TAGS,{!KEYWORDCHECK}}" type="checkbox" name="perform_keywordcheck" value="1" id="perform_keywordcheck" /></label>
					</p>
				{+END}{+END}
			</div></section>
		</div>
	{+END}{+END}
{+END}{+END}{+END}

<p class="proceed_button{+START,IF_PASSED,SUBMIT_BUTTON_CLASS} {SUBMIT_BUTTON_CLASS*}{+END}">
	{+START,IF,{$JS_ON}}
		{+START,IF_PASSED_AND_TRUE,BACK}
			<input class="button_screen buttons__back" type="button" onclick="history.back(); return false;" value="{!GO_BACK}" />
		{+END}
		{+START,IF_PASSED,BACK_URL}
			<input class="button_screen buttons__back" type="button" onclick="if (form.method=='get') { window.location='{BACK_URL;^*}'; return false; } form.action='{BACK_URL;^*}'; form.submit(); return false;" value="{!GO_BACK}" />
		{+END}
	{+END}

	{+START,IF_PASSED,EXTRA_BUTTONS}{EXTRA_BUTTONS}{+END}
	{+START,IF_PASSED_AND_TRUE,PREVIEW}{+START,IF,{$JS_ON}}{+START,IF,{$CONFIG_OPTION,enable_previews}}
		<input class="button_screen tabs__preview" onclick="if (typeof this.form=='undefined') var form=window.form_submitting; else var form=this.form; if (do_form_preview(event,form,window.form_preview_url{+START,IF_PASSED_AND_TRUE,SEPARATE_PREVIEW},true{+END})) { if ((typeof window.just_checking_requirements=='undefined') || (!window.just_checking_requirements)) form.submit(); return true; } return false;" id="preview_button" accesskey="p" tabindex="{+START,IF_PASSED,TABINDEX}{TABINDEX}{+END}{+START,IF_NON_PASSED,TABINDEX}250{+END}" type="button" value="{!PREVIEW}" />
	{+END}{+END}{+END}
	<input class="{SUBMIT_ICON*} button_screen" onclick="if (typeof this.form=='undefined') var form=window.form_submitting; else var form=this.form; return do_form_submit(form,event);"{+START,IF_NON_PASSED_OR_FALSE,SECONDARY_FORM} id="submit_button" accesskey="u"{+END} tabindex="{+START,IF_PASSED,TABINDEX}{TABINDEX}{+END}{+START,IF_NON_PASSED,TABINDEX}250{+END}"{+START,IF,{$JS_ON}} type="button"{+END}{+START,IF,{$NOT,{$JS_ON}}} type="submit"{+END} value="{SUBMIT_NAME*}" />
</p>

<script>// <![CDATA[
	window.form_preview_url='{$PREVIEW_URL;/}{$KEEP;/}{+START,IF_PASSED,THEME}&utheme={THEME;/}{+END}';

	{+START,IF_PASSED_AND_TRUE,PREVIEW}{+START,IF,{$JS_ON}}{+START,IF,{$CONFIG_OPTION,enable_previews}}
		{+START,IF,{$FORCE_PREVIEWS}}
			document.getElementById('submit_button').style.display='none';
		{+END}
	{+END}{+END}{+END}

	add_event_listener_abstract(window,'load',function() {
		{+START,IF_PASSED,JAVASCRIPT}
			{JAVASCRIPT/}
		{+END}
		{+START,IF_NON_PASSED_OR_FALSE,SECONDARY_FORM}
			if (typeof window.fix_form_enter_key!='undefined') fix_form_enter_key(document.getElementById('submit_button').form);
		{+END}

		{+START,IF_PASSED_AND_TRUE,SUPPORT_AUTOSAVE}{+START,IF_PASSED,FORM_NAME}
			{$REQUIRE_JAVASCRIPT,posting}

			if (typeof init_form_saving!='undefined') init_form_saving('{FORM_NAME;/}');
		{+END}{+END}
	});
//]]></script>

{+START,IF_PASSED_AND_TRUE,PREVIEW}{+START,IF,{$JS_ON}}{+START,IF,{$CONFIG_OPTION,enable_previews}}
	<iframe{$?,{$BROWSER_MATCHES,ie}, frameBorder="0" scrolling="no"} title="{!PREVIEW}" name="preview_iframe" id="preview_iframe" src="{$BASE_URL*}/uploads/index.html" class="hidden_preview_frame">{!PREVIEW}</iframe>
{+END}{+END}{+END}

{$,Load up the staff actions template to display staff actions uniformly (we relay our parameters to it)...}
{+START,IF,{$HAS_PRIVILEGE,see_software_docs}}{+START,IF_PASSED,STAFF_HELP_URL}{+START,IF,{$SHOW_DOCS}}
	{+START,INCLUDE,STAFF_ACTIONS}
		STAFF_ACTIONS_TITLE={!STAFF_ACTIONS}
		1_URL={STAFF_HELP_URL}
		1_TITLE={!HELP}
		1_REL=help
		1_ICON=menu/pages/help
	{+END}
{+END}{+END}{+END}

