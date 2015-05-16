{TITLE}

<p>{TEXT}</p>

{+START,IF_NON_EMPTY,{FORUM_STAFF}}
	<h2>{!SETTINGS}</h2>

	<p>{!FORUM_STAFF}</p>

	{FORUM_STAFF}
{+END}

{+START,IF_EMPTY,{FORUM_STAFF}}
	<p class="nothing_here">
		{!NO_ENTRIES}
	</p>
{+END}

