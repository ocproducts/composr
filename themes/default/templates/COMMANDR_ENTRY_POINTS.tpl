<ul>
	{$SET,points,0}
	{+START,LOOP,ENTRY_POINTS}<li>{_loop_key} ({_loop_var})</li>{$SET,points,1}{+END}
	{+START,IF,{$NOT,{$GET,points}}}
	<li>{!NONE}</li>
	{+END}
</ul>
