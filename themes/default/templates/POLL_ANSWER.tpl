{$REQUIRE_JAVASCRIPT,polls}

<div class="poll_answer" data-tpl="pollAnswer" data-tpl-params="{+START,PARAMS_JSON,PID}{_*}{+END}">
	<label for="cast{CAST*}_{PID*}">
		<input id="cast{CAST*}_{PID*}" name="cast_{PID*}" class="js-click-enable-poll-input" type="radio" value="{CAST*}" />
		{+START,FRACTIONAL_EDITABLE,{ANSWER_PLAIN},option{I},_SEARCH:cms_polls:__edit:{PID},1}{ANSWER}{+END}
	</label>
</div>
