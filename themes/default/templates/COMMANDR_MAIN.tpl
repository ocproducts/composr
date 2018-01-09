{$REQUIRE_JAVASCRIPT,core_form_interfaces}
{$REQUIRE_JAVASCRIPT,commandr}

<div id="command-line" data-tpl="commandrMain">
	<div id="commands_go_here">
		<p>{!WELCOME_TO_COMMANDR}</p>
		<hr />
		{+START,IF_NON_EMPTY,{COMMANDS}}{COMMANDS}{+END}
	</div>
	<div class="webstandards-checker-off">
		<form title="{!PRIMARY_PAGE_FORM}" autocomplete="off" action="{SUBMIT_URL*}" method="post" id="commandr_form" data-submit-pd="1" class="js-submit-commandr-form-submission" autocomplete="off">
			{$INSERT_SPAMMER_BLACKHOLE}

			<div id="command-prompt">
				<label for="commandr-command">{PROMPT*}</label>
				<input type="text" id="commandr-command" name="command" autofocus class="js-keyup-input-commandr-handle-history" />
				<input class="button-micro buttons--proceed" type="submit" value="{$STRIP_TAGS,{!PROCEED_SHORT}}" role="textbox" />
			</div>
		</form>
	</div>
</div>
