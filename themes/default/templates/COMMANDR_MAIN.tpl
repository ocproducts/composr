{$REQUIRE_JAVASCRIPT,commandr}

<div id="command_line" data-tpl="commandrMain">
	<div id="commands_go_here">
		<p>{!WELCOME_TO_COMMANDR}</p>
		<hr />
		{+START,IF_NON_EMPTY,{COMMANDS}}{COMMANDS}{+END}
	</div>
	<div class="webstandards_checker_off">
		<form title="{!PRIMARY_PAGE_FORM}" autocomplete="off" action="{SUBMIT_URL*}" method="post" id="commandr_form" data-submit-pd="1" class="js-submit-commandr-form-submission" autocomplete="off">
			{$INSERT_SPAMMER_BLACKHOLE}

			<div id="command_prompt">
				<label for="commandr_command">{PROMPT*}</label>
				<input type="text" id="commandr_command" name="command" autofocus class="js-keyup-input-commandr-handle-history" value="" />
				<input class="button_micro buttons__proceed" type="submit" value="{$STRIP_TAGS,{!PROCEED_SHORT}}" role="textbox" />
			</div>
		</form>
	</div>
</div>
