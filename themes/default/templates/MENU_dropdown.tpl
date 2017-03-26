{$REQUIRE_CSS,menu__dropdown}
{$REQUIRE_JAVASCRIPT,core_menus}

{+START,IF_NON_EMPTY,{CONTENT}}
	{$SET,menu_id,r_{MENU|}_d}

	<nav class="menu_type__dropdown" data-view="DropdownMenu" data-view-params="{+START,PARAMS_JSON,MENU,JAVASCRIPT_HIGHLIGHTING,menu_id}{_*}{+END}">
		<ul class="nl js-mouseout-unset-active-menu" id="{$GET*,menu_id}">
			{CONTENT}
		</ul>
	</nav>
{+END}
