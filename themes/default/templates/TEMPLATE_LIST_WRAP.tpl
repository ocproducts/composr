<h2>{TITLE}</h2>

{+START,IF_NON_EMPTY,{LI}}
	<nav>
		<ul class="actions_list">
			{LI}
		</ul>
	</nav>
{+END}

{+START,IF_EMPTY,{LI}}
	<p class="nothing_here">{!NONE}</p>
{+END}
