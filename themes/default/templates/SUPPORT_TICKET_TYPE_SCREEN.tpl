{TITLE}

<h2>{!EDIT_TICKET_TYPE}</h2>

{+START,IF_NON_EMPTY,{TPL}}
	{TPL}
{+END}
{+START,IF_EMPTY,{TPL}}
	<p class="nothing_here">
		{!NO_ENTRIES}
	</p>
{+END}

<h2>{!ADD_TICKET_TYPE}</h2>

{ADD_FORM}

