{$REQUIRE_CSS,menu__dropdown}
{$REQUIRE_JAVASCRIPT,menu_popup}

{+START,IF_NON_EMPTY,{CONTENT}}
	<nav class="menu_type__dropdown" data-view-core-menus="DropdownMenu" data-view-args="{+START,PARAMS_JSON,MENU,JAVASCRIPT_HIGHLIGHTING}{_*}{+END}">
		<ul class="nl js-ul-menu js-ul-menu-main" id="r_{MENU|*}_d">
			{CONTENT}
		</ul>
	</nav>
{+END}
