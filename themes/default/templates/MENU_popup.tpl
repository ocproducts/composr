{$REQUIRE_CSS,menu__popup}
{$REQUIRE_JAVASCRIPT,menu_popup}

{+START,IF_NON_EMPTY,{CONTENT}}
	<nav class="menu_type__popup" role="navigation">
		<ul onmouseout="return deset_active_menu()" class="nl" id="r_{MENU|*}_p">
			{CONTENT}
		</ul>
	</nav>
{+END}
