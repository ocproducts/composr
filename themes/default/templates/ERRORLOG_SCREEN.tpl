{TITLE}

<h2>{!ERRORS_IN_ERROR_LOG}</h2>

{ERRORS}

<ul class="actions-list">
	<li><a href="{CLEAR_URL*}">{!CLEAR}</a></li>
</ul>

{+START,LOOP,LOGS}
	<h2>{_loop_key*}</h2>

	{+START,IF_NON_EMPTY,{LOG}}
		<div class="raw-log">{LOG*}</div>
	{+END}
	{+START,IF_EMPTY,{LOG}}
		<p class="nothing-here">{!NO_ENTRIES}</p>
	{+END}

	<ul class="actions-list">
		{+START,IF_NON_EMPTY,{LOG}}
			<li><a href="{DOWNLOAD_URL*}">{!DOWNLOAD}</a></li>
			<li><a href="{CLEAR_URL*}">{!CLEAR}</a></li>
		{+END}
		<li><a href="{DELETE_URL*}">{!DELETE}</a></li>
	</ul>
{+END}
