<p {+START,IF_PASSED,CLASS} class="{CLASS*}"{+END}>
	{+START,IF,{$EQ,{CLASS},red-alert}}
		{+START,INCLUDE,ICON}
			NAME=status/notice
			SIZE=24
		{+END}
	{+END}
	{TEXT}
</p>
