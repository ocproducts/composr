{TITLE}

{$REQUIRE_JAVASCRIPT,jquery}
{$REQUIRE_JAVASCRIPT,jquery_ui}
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
	{!THEME_EDITOR_ACCESSIBILITY_HELP}
</noscript>

<form title="{!PRIMARY_PAGE_FORM}" method="post" action="{POST_URL*}">
	<input type="hidden" name="template_preview_op" value="1" />

	{$INSERT_SPAMMER_BLACKHOLE}

	<div class="float_surrounder">
		{$,Tree list}
		<div class="theme_editor_file_selector">
			<div class="inner">
				<input type="hidden" id="theme_files" name="theme_files" value="" onchange="theme_editor_add_tab_wrap();" />
				<div id="tree_list__root_theme_files">
					<!-- List put in here -->
				</div>

				<p><input onclick="disable_button_just_clicked(this); return add_template();" class="button_screen_item menu___generic_admin__add_one" type="submit" title="{!ADD_TEMPLATE_HELP}" value="{!ADD_TEMPLATE}" /></p>
			</div>
		</div>

		{$,Tabs}
		<div class="theme_editor_tabs">
			<div class="float_surrounder">
				<div class="float_surrounder">
					<div class="tabs" role="tablist" id="theme_editor_tab_headers"></div>
				</div>
				<div class="tab_surround" id="theme_editor_tab_bodies"></div>
			</div>
		</div>
	</div>
</form>

<script>// <![CDATA[
	window.theme_editor_theme='{THEME;^/}';
	{+START,IF_PASSED,ACTIVE_GUID}
		window.theme_editor_active_guid='{ACTIVE_GUID;^/}';
	{+END}

	add_event_listener_abstract(window,'load',function() {
		theme_editor_clean_tabs();

		window.sitemap=new tree_list('theme_files','data/ajax_tree.php?hook=choose_theme_files&theme={THEME;/}{$KEEP;/}',null,'',false,null,false,true);

		window.setTimeout(function() {
			{+START,LOOP,FILES_TO_LOAD}
				theme_editor_add_tab('{_loop_var;^/}');
			{+END}
		},1000);

		$('.theme_editor_file_selector').resizable();

		theme_editor_assign_unload_event();
	});
//]]></script>
