<p>{INTRODUCTION}</p>
<h3>Options</h3>
<ul>
	{$SET,options,0}
	{+START,LOOP,OPTIONS}<li>{_loop_key}: {_loop_var}</li>{$SET,options,1}{+END}
	{+START,IF,{$NOT,{$GET,options}}}
	<li>{!NONE}</li>
	{+END}
</ul>
<h3>Parameters</h3>
<ol>
	{$SET,parameters,0}
	{+START,LOOP,PARAMETERS}<li>{_loop_var}</li>{$SET,parameters,1}{+END}
	{+START,IF,{$NOT,{$GET,parameters}}}
	<li>{!NONE}</li>
	{+END}
</ol>
