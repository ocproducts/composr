{+START,IF,{$EQ,{MAX},1}}
	{ASSEMBLE}
{+END}

{+START,IF,{$NEQ,{MAX},1}}
	{+START,IF_NON_EMPTY,{ASSEMBLE}}
		<div class="banner-wave-block">
			{ASSEMBLE}
		</div>
	{+END}
{+END}
