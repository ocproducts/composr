{+START,IF,{$EQ,{MAX},1}}
	{BANNER}
{+END}

{+START,IF,{$NEQ,{MAX},1}}
	<div class="banner-wrap">
		{BANNER}
	</div>
{+END}
