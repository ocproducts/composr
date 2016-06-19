<div class="float_surrounder">
	<form title="{!FILTER}" class="right" action="{$URL_FOR_GET_FORM*,{$SELF_URL}}" method="get" autocomplete="off">
		{$HIDDENS_FOR_GET_FORM,{$SELF_URL},seconds_back}

		<p>
			<label for="seconds_back" class="accessibility_hidden">{!FILTER}</label>
			<select name="seconds_back" id="seconds_back" onchange="/*guarded*/this.form.submit();">
				<option value="">{!POSTS_SINCE_LAST_VISIT}</option>
				{+START,LOOP,5\,10\,30}
					<option{+START,IF,{$EQ,{$_GET,seconds_back},{$MULT*,60,{_loop_var}}}} selected="selected"{+END} value="{$MULT*,60,{_loop_var}}">{!POSTS_SINCE_MINUTES,{$NUMBER_FORMAT*,{_loop_var}}}</option>
				{+END}
				{+START,LOOP,1\,2\,6\,12}
					<option{+START,IF,{$EQ,{$_GET,seconds_back},{$MULT*,3600,{_loop_var}}}} selected="selected"{+END} value="{$MULT*,3600,{_loop_var}}">{!POSTS_SINCE_HOURS,{$NUMBER_FORMAT*,{_loop_var}}}</option>
				{+END}
				{+START,LOOP,1\,2\,3\,4\,5\,6}
					<option{+START,IF,{$EQ,{$_GET,seconds_back},{$MULT*,86400,{_loop_var}}}} selected="selected"{+END} value="{$MULT*,86400,{_loop_var}}">{!POSTS_SINCE_DAYS,{$NUMBER_FORMAT*,{_loop_var}}}</option>
				{+END}
				{+START,LOOP,1\,2}
					<option{+START,IF,{$EQ,{$_GET,seconds_back},{$MULT*,604800,{_loop_var}}}} selected="selected"{+END} value="{$MULT*,604800,{_loop_var}}">{!POSTS_SINCE_WEEKS,{$NUMBER_FORMAT*,{_loop_var}}}</option>
				{+END}
			</select>{+START,IF,{$NOT,{$JS_ON}}}<input type="submit" class="button_micro buttons__filter" value="{!FILTER}" />{+END}
		</p>
	</form>
</div>