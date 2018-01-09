{$REQUIRE_CSS,menu__embossed}

{+START,IF_NON_EMPTY,{CONTENT}}
	{$SET,menu_id,r_{MENU|}}
	<nav class="menu-type--embossed" data-view="Menu" data-view-params="{+START,PARAMS_JSON,MENU,JAVASCRIPT_HIGHLIGHTING,menu_id}{_*}{+END}">
		<ul class="nl" id="{$GET,menu_id}">
			{CONTENT}
		</ul>
	</nav>
{+END}
