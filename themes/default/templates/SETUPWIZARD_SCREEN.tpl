{TITLE}

<div class="box box___setupwizard"><div class="box_inner">
	<div class="progress_indicator">
		{+START,LOOP,1\,2\,3\,4\,5\,6\,7\,8\,9\,10}<img alt="" src="{$IMG*,progress_indicator/{$?,{$LT,{STEP},{_loop_var}},stage_future,{$?,{$EQ,{STEP},{_loop_var}},stage_present,stage_past}}}" />{+END}
	</div>

	<h2>{!SETUPWIZARD_STEP,{$NUMBER_FORMAT,{STEP}},{$NUMBER_FORMAT,10}}</h2>

	{INNER}
</div></div>
