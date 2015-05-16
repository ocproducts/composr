<ul>
	{$SET,listing,0}
	{+START,LOOP,FILES}<li class="commandr_file">{_loop_var}</li>{$SET,listing,1}{+END}
	{+START,IF,{$NOT,{$GET,listing}}}
	<li>{!NONE}</li>
	{+END}
</ul>
