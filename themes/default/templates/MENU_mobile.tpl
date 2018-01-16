{$REQUIRE_CSS,menu__mobile}
{$REQUIRE_JAVASCRIPT,core_menus}

{+START,IF_NON_EMPTY,{CONTENT}}
	{$SET,menu_id,r_{MENU|}_mobile_d}
	<div data-view="MobileMenu" data-view-params="{+START,PARAMS_JSON,MENU,JAVASCRIPT_HIGHLIGHTING,menu_id}{_*}{+END}">
		<a href="{$PAGE_LINK*,:sitemap}" class="mobile-menu-button js-click-toggle-content"><img src="{$IMG*,mobile_menu}" alt="{!MENU}" /> <span>{!MENU}</span></a>

		<nav class="menu-type--mobile js-el-menu-content" style="display: none" aria-expanded="false">
			<div class="mobile-search">
				{$BLOCK,block=top_search,failsafe=1,block_id=mobile}
			</div>

			<ul class="nl" id="{$GET,menu_id}">
				{CONTENT}
			</ul>
		</nav>
	</div>
{+END}
