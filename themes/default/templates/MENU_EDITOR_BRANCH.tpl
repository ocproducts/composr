{$REQUIRE_JAVASCRIPT,core_menus}

<div class="menu-editor-branch-wrap" data-tpl="menuEditorBranch" data-tpl-params="{+START,PARAMS_JSON,CLICKABLE_SECTIONS, I}{_*}{+END}">
	{CHILD_BRANCHES}

	<div id="branches_go_before_{I*}"><span style="display: none"></span></div>

	<ul class="actions-list">
		<li>
			<a rel="add" href="#!" id="add_new_menu_linka_{I*}" class="js-click-add-new-menu-item"><img class="vertical-alignment" alt="" src="{$IMG*,1x/treefield/expand}" srcset="{$IMG*,2x/treefield/expand} 2x" /></a>
			<a class="vertical-alignment js-click-add-new-menu-item" rel="add" href="#!" id="add_new_menu_linkb_{I*}">{!ADD_BRANCH}</a>
		</li>
	</ul>
</div>
