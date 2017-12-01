{$REQUIRE_CSS,menu__dropdown}
{$REQUIRE_JAVASCRIPT,core_menus}

{+START,IF_NON_EMPTY,{CONTENT}}
	{$SET,menu_id,r_{MENU|}_d}

	<div class="menu_type__dropdown" data-view="DropdownMenu" data-view-params="{+START,PARAMS_JSON,MENU,JAVASCRIPT_HIGHLIGHTING,menu_id}{_*}{+END}">
		<a href="{$PAGE_LINK*,:sitemap}" class="menu-dropdown-toggle-btn js-click-toggle-menu-content"><img src="{$IMG*,mobile_menu}" alt="{!MENU}" /> <span>{!MENU}</span></a>
		
		<nav class="menu-dropdown-content js-el-menu-content">
			<ul class="nl js-mouseout-unset-active-menu" id="{$GET*,menu_id}">
				{CONTENT}
			</ul>
		</nav>
	</div>
{+END}
