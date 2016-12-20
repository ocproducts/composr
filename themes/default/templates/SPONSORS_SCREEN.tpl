{TITLE}

<p{+START,IF_NON_EMPTY,{PATREONS}} class="lonely_label"{+END}>{!PROJECT_SPONSORS_LABEL}</p>
{+START,IF_NON_EMPTY,{PATREONS}}
	<ul>
		{+START,LOOP,PATREONS}
			<li>{NAME*}</li>
		{+END}
	</ul>
{+END}
{+START,IF_EMPTY,{PATREONS}}
	<p class="nothing_here">{!NO_ENTRIES}</p>
{+END}
