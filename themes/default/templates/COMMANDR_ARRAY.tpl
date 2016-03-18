{+START,IF_NON_EMPTY,{ELEMENTS}}
	<ul>
		{+START,LOOP,ELEMENTS}
			<li>{KEY*} &rarr; {VALUE*}</li>
		{+END}
	</ul>
{+END}
