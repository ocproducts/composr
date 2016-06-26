{$REQUIRE_CSS,shoutbox}

<section class="box box___block_side_shoutbox" role="marquee"><div class="box_inner">
	<h3>{!SHOUTBOX}</h3>

	{MESSAGES}

	<form target="_self" action="{$EXTEND_URL*,{URL},posted=1}" method="post" title="{!SHOUTBOX}" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		<div>
			<p class="accessibility_hidden"><label for="shoutbox_message">{!MESSAGE}</label></p>
			<p class="constrain_field"><input autocomplete="off" value="" type="text" onfocus="placeholder_focus(this);" onblur="placeholder_blur(this);" id="shoutbox_message" name="shoutbox_message" alt="{!MESSAGE}" class="wide_field field_input_non_filled" /></p>
		</div>

		<div class="float_surrounder">
			<input style="margin: 0" onclick="window.top.setTimeout(function() { window.top.sb_chat_check(window.top.sb_last_message_id,-1); }, 2000); if (!check_field_for_blankness(this.form.elements['shoutbox_message'],event)) return false; disable_button_just_clicked(this); return true" type="submit" value="Send" class="button_screen_item buttons__send" />
			<input style="margin: 0" onclick="this.form.elements['shoutbox_message'].value='((SHAKE))'; window.top.setTimeout(function() { window.top.sb_chat_check(window.top.sb_last_message_id,-1); }, 2000); disable_button_just_clicked(this);" type="submit" title="Shake the screen of all active website visitors" value="Shake" class="button_screen_item menu___generic_spare__8" />
		</div>
	</form>

	<script>// <![CDATA[
		var sb_room_id={CHATROOM_ID%};
		add_event_listener_abstract(window,'load',function() {
			{+START,IF_NON_EMPTY,{LAST_MESSAGE_ID}}
				sb_chat_check({LAST_MESSAGE_ID%},-1);
			{+END}
		});
	//]]></script>
</div></section>
