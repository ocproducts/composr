{$REQUIRE_JAVASCRIPT,commandr}

<div class="command float-surrounder" data-require-javascript="commandr" data-tpl="commandrCommand" data-tpl-params="{+START,PARAMS_JSON,STDCOMMAND}{_*}{+END}">
	<p class="past_command_prompt">{METHOD*} &rarr;</p>
	<div class="past_command">
		{+START,IF_NON_EMPTY,{STDOUT}}<p class="text_output">{STDOUT*}</p>{+END}
		{STDHTML}
		{+START,IF_NON_EMPTY,{STDERR}}<p class="red_alert" role="error">{STDERR}</p>{+END}
	</div>
</div>
