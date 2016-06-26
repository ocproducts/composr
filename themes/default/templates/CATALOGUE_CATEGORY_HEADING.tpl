<h2>{LETTER*}</h2>

{+START,IF_NON_EMPTY,{ENTRIES*}}
	{ENTRIES}
{+END}
{+START,IF_EMPTY,{ENTRIES*}}
	<p class="nothing_here">{!NO_ENTRIES,catalogue_entry}</p>
{+END}
