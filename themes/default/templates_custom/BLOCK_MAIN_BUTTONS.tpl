<section class="box box___block_main_buttons"><div class="box-inner">
	<h3>{TITLE*}</h3>

	{+START,IF,{$EQ,{EXTRA},side}}
		<div class="banner_side"{SET_HEIGHT}>
			{ASSEMBLE}
		</div>
	{+END}

	{+START,IF,{$NEQ,{EXTRA},side}}
		<div {SET_HEIGHT}>
			{ASSEMBLE}
		</div>
	{+END}
</div></section>
