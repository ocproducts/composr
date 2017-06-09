<section class="box box___block_main_join_done"><div class="box_inner">
	<h3>{!_JOIN}</h3>

	{+START,IF_PASSED,MESSAGE}
		{MESSAGE}
	{+END}
	{+START,IF_NON_PASSED,MESSAGE}
		<p>
			{!WELCOME_BACK,{$USERNAME*}}
		</p>
	{+END}
</div></section>
