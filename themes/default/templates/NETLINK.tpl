<form title="{!JUMP} ({!FORM_AUTO_SUBMITS})" method="get" action="{$FIND_SCRIPT*,netlink}" autocomplete="off">
	<div>
		<div class="constrain_field">
			<p class="accessibility_hidden"><label for="netlink_url">{!JUMP}</label></p>
			<select{+START,IF,{$JS_ON}} onchange="/*guarded*/this.form.submit();"{+END} id="netlink_url" name="url" class="wide_field">
				{CONTENT}
			</select>
		</div>
		{+START,IF,{$NOT,{$JS_ON}}}
			<p class="proceed_button">
				<input onclick="disable_button_just_clicked(this);" type="submit" value="{!PROCEED}" class="button_screen_item buttons__proceed" />
			</p>
		{+END}
	</div>
</form>

