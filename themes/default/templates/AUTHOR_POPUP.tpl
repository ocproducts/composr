{+START,IF_NON_EMPTY,{CONTENT}}
	<ul class="compact_list">
		{CONTENT}
	</ul>
{+END}
{+START,IF_EMPTY,{CONTENT}}
	<p class="nothing_here">
		{!NO_ENTRIES}
	</p>
{+END}

{+START,IF_PASSED,NEXT_URL}
	<hr />

	<ul class="actions_list" role="navigation">
		<li><a title="{!MORE}: {!AUTHORS}" href="{NEXT_URL*}">{!MORE}</a></li>
	</ul>
{+END}
