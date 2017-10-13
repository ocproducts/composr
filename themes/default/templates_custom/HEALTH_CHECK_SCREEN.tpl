{TITLE}

<form action="{$SELF_URL*}" method="post">
	{$INSERT_SPAMMER_BLACKHOLE}

	<div>
		<label for="sections_to_run" class="lonely_label">{!SECTIONS}:</label>
		<select name="sections_to_run[]" id="sections_to_run" multiple="multiple" size="10">
			{SECTIONS}
		</select>
	</div>

	<div class="float_surrounder force_margin">
		<div class="left float_separation">
			<label for="fails">{!SHOW_FAILS}:</label>
			<input type="checkbox" name="fails" id="fails" value="1" checked="checked" disabled="disabled" />
		</div>

		<div class="left float_separation">
			<label for="passes">{!SHOW_PASSES}:</label>
			<input type="checkbox" name="passes" id="passes" value="1"{+START,IF,{PASSES}} checked="checked"{+END} />
		</div>

		<div class="left float_separation">
			<label for="skips">{!SHOW_SKIPS}:</label>
			<input type="checkbox" name="skips" id="skips" value="1"{+START,IF,{SKIPS}} checked="checked"{+END} />
		</div>

		<div class="left float_separation">
			<label for="manual_checks">{!SHOW_MANUAL_CHECKS}:</label>
			<input type="checkbox" name="manual_checks" id="manual_checks" value="1"{+START,IF,{MANUAL_CHECKS}} checked="checked"{+END} />
		</div>
	</div>

	<p class="proceed_button">
		<input class="button_screen buttons__proceed" type="submit" value="{!HEALTH_CHECK}" />
	</p>
</form>

{+START,IF_PASSED,RESULTS}
	{RESULTS}
{+END}
