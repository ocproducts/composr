{$REQUIRE_JAVASCRIPT,commandr}

<div class="command clearfix" data-tpl="commandrCommand" data-tpl-params="{+START,PARAMS_JSON,STDCOMMAND}{_*}{+END}">
	<p class="past-command-prompt">{METHOD*} &rarr;</p>
	<div class="past-command">
		{+START,IF_NON_EMPTY,{STDOUT}}<p class="text-output">{STDOUT*}</p>{+END}
		{STDHTML}
		{+START,IF_NON_EMPTY,{STDERR}}
			{+START,INCLUDE,RED_ALERT}
				ROLE=error
				TEXT={STDERR}
			{+END}
		{+END}
	</div>
</div>
