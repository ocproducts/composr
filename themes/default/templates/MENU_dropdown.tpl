{$REQUIRE_CSS,menu__dropdown}
{$REQUIRE_JAVASCRIPT,core_menus}

{+START,IF_NON_EMPTY,{CONTENT}}
	{$SET,menu_id,r-{MENU|}-d}

	<div class="dropdown-menu" data-view="DropdownMenu" data-view-params="{+START,PARAMS_JSON,MENU,JAVASCRIPT_HIGHLIGHTING,menu_id}{_*}{+END}">
		<a href="{$PAGE_LINK*,:sitemap}" class="dropdown-menu-toggle-btn js-click-toggle-menu-content">{+START,INCLUDE,ICON}NAME=menus/mobile_menu{+END} <span>{!MENU}</span></a>

		<nav class="dropdown-menu-content js-el-menu-content">
			<ul class="dropdown-menu-items dropdown-menu-items-main nl js-mouseout-unset-active-menu" id="{$GET*,menu_id}">
				{CONTENT}
			</ul>
		</nav>
	</div>
{+END}
