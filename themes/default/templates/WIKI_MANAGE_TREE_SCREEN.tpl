<div data-tpl="wikiManageTreeScreen">

{TITLE}

{+START,INCLUDE,HANDLE_CONFLICT_RESOLUTION}{+END}
{+START,IF_PASSED,WARNING_DETAILS}
	{WARNING_DETAILS}
{+END}

<h2>{!HELP}</h2>

{+START,SET,advanced_help}
	<div class="ttb_left_spaced" data-view="ToggleableTray">
		<div class="js-tray-header">
			<a class="toggleable_tray_button ttb_left js-btn-tray-toggle" href="#!"><img alt="{!EXPAND}: {!ADVANCED}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand}" srcset="{$IMG*,2x/trays/expand} 2x" /></a>
			<a class="toggleable_tray_button ttb_light js-btn-tray-toggle" href="#!">{!WIKI_MANAGE_TREE_TEXT_ADVANCED_LABEL}</a>:
		</div>

		<div class="toggleable_tray js-tray-content" style="display: {$JS_ON,none,block}" aria-expanded="false">
			{!WIKI_MANAGE_TREE_TEXT_ADVANCED}
		</div>
	</div>
{+END}

{!WIKI_MANAGE_TREE_TEXT,{$GET,advanced_help},{PAGE_TITLE*}}

<h2>{!SETTINGS}</h2>

{FORM}

{+START,IF_NON_EMPTY,{WIKI_TREE}}
	<h2>{!ID_ASSISTANCE_TOOL}</h2>

	<form title="{!PRIMARY_PAGE_FORM}" method="post" action="index.php" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		<p><label for="mtp_tree">{!BROWSE_ID_INSERT}</label></p>

		<div>
			{+START,IF,{$JS_ON}}
				{$REQUIRE_JAVASCRIPT,ajax}
				{$REQUIRE_JAVASCRIPT,tree_list}
				{$REQUIRE_JAVASCRIPT,wiki}

				<input style="display: none" type="text" id="mtp_tree" name="tree" value="" onchange="if (this.form.elements['tree'].value!='') document.getElementById('children').value+=this.value+'='+this.selected_title+'\n';" />
				<div id="tree_list__root_mtp_tree">
					<!-- List put in here -->
				</div>
			{+END}

			{+START,IF,{$NOT,{$JS_ON}}}
				<select id="mtp_tree" name="tree">
					{WIKI_TREE}
				</select>

				<input class="button_screen_item menu___generic_admin__add_to_category" type="button" value="{!ADD}" onclick="if (this.form.elements['tree'].value!='') document.getElementById('children').value+=this.form.elements['tree'].value+'\n'" />
			{+END}
		</div>
	</form>
{+END}

</div>