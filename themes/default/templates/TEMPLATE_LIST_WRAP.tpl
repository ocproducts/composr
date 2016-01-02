<h2>{TITLE}</h2>

{+START,IF_NON_EMPTY,{LI}}
	<ul role="navigation" class="actions_list">
		{LI}
	</ul>
{+END}

{+START,IF_EMPTY,{LI}}
	<p class="nothing_here">{!NONE}</p>
{+END}
