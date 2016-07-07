{$REQUIRE_CSS,menu__popup}
{$REQUIRE_JAVASCRIPT,menu_popup}

{+START,IF_NON_EMPTY,{CONTENT}}
	<nav class="menu_type__popup">
		<ul onmouseout="return deset_active_menu()" class="nl" id="r_{MENU|*}_p">
			{CONTENT}
		</ul>
	</nav>

	{+START,IF_PASSED_AND_TRUE,JAVASCRIPT_HIGHLIGHTING}
		<script>// <![CDATA[
			menu_active_selection('r_{MENU|}_p');
		//]]></script>
	{+END}
{+END}
