{TITLE}

{TEXT}

{$,If not staff and adding banner then there's a chance you'll be using a banner network on your own website, so show details - staff can see this stuff in the docs anyway}
{+START,IF,{$NOT,{$IS_STAFF}}}
	<h2>{!DISPLAYING_BANNER_ROTATION}</h2>

	<p>
		{!BANNER_CLICK_SCHEME}
	</p>
	<div>
		<code>
	{BANNER_CODE}
		</code>
	</div>
{+END}

<h2>{!_STATISTICS}</h2>

<p>
	{!ACCESS_BANNER_INFO,{STATS_URL*}}
</p>

{+START,IF_NON_EMPTY,{DO_NEXT}}
	<h2>{!do_next:WHAT_NEXT}</h2>

	{DO_NEXT}
{+END}
