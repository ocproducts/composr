{$REQUIRE_CSS,menu__tree}
{+START,IF_NON_EMPTY,{CONTENT}}
	{$SET,menu_id,r_{MENU|}}
	<nav class="menu_type__tree" data-view="TreeMenu" data-view-args="{+START,PARAMS_JSON,MENU,JAVASCRIPT_HIGHLIGHTING,menu_id}{_*}{+END}">
		<ul class="nl" id="{$GET*,menu_id}">
			{CONTENT}
		</ul>
	</nav>
{+END}
