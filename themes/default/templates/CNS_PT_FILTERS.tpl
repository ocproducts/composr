{+START,IF_NON_EMPTY,{FILTERS}}
	{$SET,has_filter,0}

	{+START,LOOP,FILTERS}
		{+START,IF_NON_EMPTY,{URL}}
			<a href="{URL*}">{CAPTION*}</a>{+START,IF,{HAS_NEXT}},{+END}
		{+END}

		{+START,IF_EMPTY,{URL}}
			<em>{CAPTION*}</em>{+START,IF,{HAS_NEXT}},{+END}

			{$SET,has_filter,1}
		{+END}
	{+END}

	{+START,IF,{$GET,has_filter}}
		<span class="associated_details right">(<a href="{RESET_URL*}">reset</a>)</span>
	{+END}
{+END}
