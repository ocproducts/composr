{$REQUIRE_CSS,menu__dropdown}
{$REQUIRE_JAVASCRIPT,core_menus}

{+START,IF_NON_EMPTY,{CONTENT}}
	{$SET,menu_id,r-{MENU|}-d}

	<div class="menu-dropdown" data-view="DropdownMenu" data-view-params="{+START,PARAMS_JSON,MENU,JAVASCRIPT_HIGHLIGHTING,menu_id}{_*}{+END}">
		<a href="{$PAGE_LINK*,:sitemap}" class="menu-dropdown-toggle-btn">{+START,INCLUDE,ICON}NAME=menus/mobile_menu{+END} <span>{!MENU}</span></a>

		<nav class="menu-dropdown-content">
			<ul class="menu-dropdown-items menu-dropdown-items-main" id="{$GET*,menu_id}">
				{CONTENT}
			</ul>
		</nav>
	</div>
{+END}
