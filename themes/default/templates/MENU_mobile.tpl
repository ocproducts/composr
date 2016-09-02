{$REQUIRE_CSS,menu__mobile}
{$REQUIRE_JAVASCRIPT,menu_mobile}

{+START,IF_NON_EMPTY,{CONTENT}}
	{$SET,menu_id,r_{MENU|}_d}
	<a href="{$PAGE_LINK*,:sitemap}" class="mobile_menu_button" onclick="return mobile_menu_button('{MENU|;*}');"><img src="{$IMG*,mobile_menu}" alt="{!MENU}" /> <span>{!MENU}</span></a>

	<nav class="menu_type__mobile" style="display: none" aria-expanded="false" data-view-core-menus="Menu" data-view-args="{+START,PARAMS_JSON,MENU,JAVASCRIPT_HIGHLIGHTING,menu_id}{_*}{+END}">
		<div class="mobile_search">
			{$BLOCK,block=top_search,failsafe=1}
		</div>

		<ul class="nl" id="{$GET,menu_id}">
			{CONTENT}
		</ul>
	</nav>
{+END}
