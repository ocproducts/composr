{$REQUIRE_CSS,menu__mobile}
{$REQUIRE_JAVASCRIPT,core_menus}
{$SET,menu_id,r_{MENU|}_mobile_d}

<a data-tpl="menuMobile" data-tpl-params="{+START,PARAMS_JSON,menu_id}{_*}{+END}" href="{$PAGE_LINK*,:sitemap}" class="mobile_menu_button js-click-toggle-{$GET,menu_id}-content">
	<img src="{$IMG*,mobile_menu}" alt="{!MENU}" />	<span>{!MENU}</span>
</a>

{+START,IF_NON_EMPTY,{CONTENT}}
	<nav class="menu_type__mobile" style="display: none" aria-expanded="false" data-view="MobileMenu" data-view-params="{+START,PARAMS_JSON,MENU,JAVASCRIPT_HIGHLIGHTING,menu_id}{_*}{+END}">
		<div class="mobile_search">
			{+START,INCLUDE,ADMIN_ZONE_SEARCH}{+END}
		</div>

		<ul class="nl" id="{$GET,menu_id}">
			{CONTENT}
		</ul>
	</nav>
{+END}
