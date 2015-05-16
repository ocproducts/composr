<section class="box box___block_main_buttons"><div class="box_inner">
	<h3>{TITLE*}</h3>

{+START,IF,{$EQ,{EXTRA},side}}
	<div class="banner_side"{SET_HEIGHT}>
		{ASSEMBLE}
	</div>
</div></section>
{+START,IF,{$NEQ,{EXTRA},side}}
	<div{SET_HEIGHT}>
		{ASSEMBLE}
	</div>
{+END}

{+END}

