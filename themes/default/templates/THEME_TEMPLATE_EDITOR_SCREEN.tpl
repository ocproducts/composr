{TITLE}

{$REQUIRE_JAVASCRIPT,jquery}
{$REQUIRE_JAVASCRIPT,jquery_ui}
{$REQUIRE_JAVASCRIPT,dyn_comcode}
{$REQUIRE_CSS,jquery_ui}

{+START,IF,{$CONFIG_OPTION,editarea}}
	<script src="{$BASE_URL*}/data/ace/ace.js"></script>
	<script src="{$BASE_URL*}/data/ace/ace_composr.js"></script>
{+END}

{+START,INCLUDE,HANDLE_CONFLICT_RESOLUTION}{+END}
{+START,IF_PASSED,WARNING_DETAILS}
	{WARNING_DETAILS}
{+END}

<noscript>
	{!TEMPLATE_EDITOR_ACCESSIBILITY_HELP}
</noscript>

<form title="{!PRIMARY_PAGE_FORM}" method="post" action="#" autocomplete="off">
	{$,Instruct Composr to pull in template data dynamically from the POST environment, i.e. do a live preview}
	<input type="hidden" name="template_preview_op" value="1" />

	{$INSERT_SPAMMER_BLACKHOLE}

	<div class="float_surrounder">
		{$,Tree list}
		<div class="template_editor_file_selector">
			<div class="inner">
				<input type="hidden" id="theme_files" name="theme_files" value="{+START,IF_PASSED,DEFAULT_THEME_FILES_LOCATION}{DEFAULT_THEME_FILES_LOCATION*}{+END}" onchange="template_editor_add_tab_wrap();" />
				<div id="tree_list__root_theme_files">
					<!-- List put in here -->
				</div>

				<p><input data-disable-on-click="{}" onclick="return add_template();" class="button_screen_item menu___generic_admin__add_one" type="submit" title="{!ADD_TEMPLATE_HELP}" value="{!ADD_TEMPLATE}" /></p>
			</div>
		</div>

		{$,Tabs}
		<div class="template_editor_tabs">
			<div class="float_surrounder">
				<div class="float_surrounder">
					<div class="tabs spaced_out_tabs" role="tablist" id="template_editor_tab_headers"></div>
				</div>
				<div class="tab_surround" id="template_editor_tab_bodies"></div>
			</div>
		</div>
	</div>
</form>

<script type="application/json" data-tpl-core-themeing="themeTemplateEditorScreen">
	{+START,PARAMS_JSON,THEME,ACTIVE_GUID,LIVE_PREVIEW_URL,FILES_TO_LOAD}{_/}{+END}
</script>