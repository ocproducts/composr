<div class="ltNewsHold">
	<h3><a href="{FULL_URL*}">{NEWS_TITLE}</a></h3>
	<span>{DATE*}</span>

	{+START,IF_NON_EMPTY,{NEWS}}
		{+START,IF,{$AND,{$NOT,{$IN_STR,{NEWS},<p><div>}},{$NOT,{$IN_STR,{NEWS},<h}}}}<p>{+END}
		{+START,IF,{TRUNCATE}}{$TRUNCATE_LEFT,{NEWS},130,0,1}{+END}
		{+START,IF,{$NOT,{TRUNCATE}}}{NEWS}{+END}
		{+START,IF,{$AND,{$NOT,{$IN_STR,{NEWS},<p><div>}},{$NOT,{$IN_STR,{NEWS},<h}}}}</p>{+END}
	{+END}
</div>
