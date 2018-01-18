<section class="box box---block-main-buttons"><div class="box-inner">
	<h3>{TITLE*}</h3>

	{+START,IF,{$EQ,{EXTRA},side}}
		<div class="banner-side"{SET_HEIGHT}>
			{ASSEMBLE}
		</div>
	{+END}

	{+START,IF,{$NEQ,{EXTRA},side}}
		<div {SET_HEIGHT}>
			{ASSEMBLE}
		</div>
	{+END}
</div></section>
