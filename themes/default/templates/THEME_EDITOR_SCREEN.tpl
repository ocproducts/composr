{TITLE}

{+START,INCLUDE,HANDLE_CONFLICT_RESOLUTION}{+END}
{+START,IF_PASSED,WARNING_DETAILS}
	{WARNING_DETAILS}
{+END}

<form title="{!PRIMARY_PAGE_FORM}" method="post" action="{POST_URL*}">
	<input type="hidden" name="template_preview_op" value="1" />

	{$INSERT_SPAMMER_BLACKHOLE}

	<div class="float_surrounder">
		{$,Tree list}
		<div class="theme_editor_file_selector">
			<input type="hidden" id="theme_files" name="theme_files" value="" />
			<div id="tree_list__root_theme_files">
				<!-- List put in here -->
			</div>

			<input onclick="disable_button_just_clicked(this); return add_template();" class="button_screen menu___generic_admin__add_one" type="submit" title="{!ADD_TEMPLATE_HELP}" value="{!ADD_TEMPLATE}" />
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

		{+START,LOOP,FILES_TO_LOAD}
			theme_editor_add_tab('{_loop_var;^/}');
		{+END}
	});
//]]></script>

{+START,IF,{$CONFIG_OPTION,editarea}}
	<script language="javascript" src="{$BASE_URL*}/data/ace/ace.js"></script>
	<script language="javascript" src="{$BASE_URL*}/data/ace/ace_composr.js"></script>
{+END}
