{$REQUIRE_CSS,menu__tree}

{+START,IF_NON_EMPTY,{CONTENT}}
	<nav class="menu_type__tree" role="navigation">
		<ul class="nl">
			{CONTENT}
		</ul>
	</nav>
{+END}
