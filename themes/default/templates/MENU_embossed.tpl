{$REQUIRE_CSS,menu__embossed}

{+START,IF_NON_EMPTY,{CONTENT}}
	<nav class="menu_type__embossed">
		<ul class="nl" id="r_{MENU|}" {+START,IF_PASSED_AND_TRUE,JAVASCRIPT_HIGHLIGHTING}data-cms-call="menu_active_selection"{+END}>
			{CONTENT}
		</ul>
	</nav>
{+END}