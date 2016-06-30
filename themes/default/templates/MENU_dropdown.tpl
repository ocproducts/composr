{$REQUIRE_CSS,menu__dropdown}
{$REQUIRE_JAVASCRIPT,menu_popup}

{+START,IF_NON_EMPTY,{CONTENT}}
	<nav class="menu_type__dropdown">
		<ul onmouseout="return deset_active_menu()" class="nl" id="r_{MENU|*}_d">
			{CONTENT}
		</ul>
	</nav>

	{+START,IF_PASSED_AND_TRUE,JAVASCRIPT_HIGHLIGHTING}
		<script>// <![CDATA[
			menu_active_selection('r_{MENU|}_d');
		//]]></script>
	{+END}
{+END}
