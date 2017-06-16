{$REQUIRE_JAVASCRIPT,commandr}

<ul data-tpl="commandrCommands">
	{+START,LOOP,COMMANDS}
		<li class="js-click-enter-command" data-tp-command="{_loop_var*}">{_loop_var*}</li>
	{+END}
</ul>
