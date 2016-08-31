{$REQUIRE_CSS,menu__embossed}

{+START,IF_NON_EMPTY,{CONTENT}}
	<nav class="menu_type__embossed" data-view-core-menus="Menu" data-view-args="{+START,PARAMS_JSON,MENU,JAVASCRIPT_HIGHLIGHTING}{_*}{+END}">
		<ul class="nl" id="r_{MENU|}">
			{CONTENT}
		</ul>
	</nav>
{+END}