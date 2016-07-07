{$REQUIRE_CSS,menu__tree}

{+START,IF_NON_EMPTY,{CONTENT}}
	<nav class="menu_type__tree">
		<ul class="nl" id="r_{MENU|}">
			{CONTENT}
		</ul>
	</nav>

	{+START,IF_PASSED_AND_TRUE,JAVASCRIPT_HIGHLIGHTING}
		<script>// <![CDATA[
			menu_active_selection('r_{MENU|}');
		//]]></script>
	{+END}
{+END}
