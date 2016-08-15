<div id="command_line">
	<div id="commands_go_here">
		<p>{!WELCOME_TO_COMMANDR}</p>
		<hr />
		{+START,IF_NON_EMPTY,{COMMANDS}}{COMMANDS}{+END}
	</div>
	<div class="webstandards_checker_off">
		<form title="{!PRIMARY_PAGE_FORM}" autocomplete="off" action="{SUBMIT_URL*}" method="post" id="commandr_form" onsubmit="return commandr_form_submission(document.getElementById('commandr_command').value,this);" autocomplete="off">
			{$INSERT_SPAMMER_BLACKHOLE}

			<div id="command_prompt">
				<label for="commandr_command">{PROMPT*}</label>
				<input type="text" id="commandr_command" name="command" onkeyup="return commandr_handle_history(this,event.keyCode?event.keyCode:event.charCode,event);" value="" /><input class="button_micro buttons__proceed" type="submit" value="{$STRIP_TAGS,{!PROCEED_SHORT}}" role="textbox" />
			</div>
		</form>
	</div>
	<script>
	// <![CDATA[
		add_event_listener_abstract(window,'load',function() {
			try { document.getElementById("commandr_command").focus(); } catch (e) { }
		});
	// ]]>
	</script>
</div>
