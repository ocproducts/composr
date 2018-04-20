{$REQUIRE_JAVASCRIPT,core_menus}

<div class="menu-editor-branch-wrap" data-tpl="menuEditorBranch" data-tpl-params="{+START,PARAMS_JSON,CLICKABLE_SECTIONS, I}{_*}{+END}">
	{CHILD_BRANCHES}

	<div id="branches-go-before-{I*}"><span style="display: none"></span></div>

	<ul class="actions-list">
		<li>
			{+START,INCLUDE,ICON}NAME=buttons/proceed2{+END} 
			<a rel="add" href="#!" id="add-new-menu-linka-{I*}" class="js-click-add-new-menu-item"><img class="vertical-alignment" alt="" width="16" height="16" src="{$IMG*,icons/tree_field/expand}" /></a>
			<a class="vertical-alignment js-click-add-new-menu-item" rel="add" href="#!" id="add-new-menu-linkb-{I*}">{!ADD_BRANCH}</a>
		</li>
	</ul>
</div>
