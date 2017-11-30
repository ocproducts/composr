<div data-tpl="wikiManageTreeScreen">
	{TITLE}

	{+START,INCLUDE,HANDLE_CONFLICT_RESOLUTION}{+END}
	{+START,IF_PASSED,WARNING_DETAILS}
		{WARNING_DETAILS}
	{+END}

	<h2>{!HELP}</h2>

	{+START,SET,advanced_help}
		<div class="ttb_left_spaced" data-toggleable-tray="{}">
			<div class="js-tray-header">
				<a class="toggleable_tray_button ttb_left js-tray-onclick-toggle-tray" href="#!"><img alt="{!EXPAND}: {!ADVANCED}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand}" /></a>
				<a class="toggleable_tray_button ttb_light js-tray-onclick-toggle-tray" href="#!">{!WIKI_MANAGE_TREE_TEXT_ADVANCED_LABEL}</a>:
			</div>

			<div class="toggleable_tray js-tray-content" style="display: none" aria-expanded="false">
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
				{$REQUIRE_JAVASCRIPT,tree_list}
				{$REQUIRE_JAVASCRIPT,wiki}

				<input style="display: none" type="text" id="mtp_tree" name="tree" class="js-change-input-tree-update-children-value" />
				<div id="tree_list__root_mtp_tree">
					<!-- List put in here -->
				</div>
			</div>
		</form>
	{+END}
</div>
