{$REQUIRE_CSS,menu__mobile}
{$REQUIRE_JAVASCRIPT,menu_mobile}

{+START,IF_NON_EMPTY,{CONTENT}}
	<a href="{$PAGE_LINK*,:sitemap}" class="mobile_menu_button" onclick="return mobile_menu_button('{MENU|;*}');"><img src="{$IMG*,mobile_menu}" alt="{!MENU}" /> <span>{!MENU}</span></a>

	<nav class="menu_type__mobile" style="display: none" aria-expanded="false">
		<ul class="nl" id="r_{MENU|*}_d">
			{CONTENT}
		</ul>
	</nav>
{+END}
