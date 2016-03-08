<div id="status_updates" class="float_surrounder">
	{+START,IF_NON_EMPTY,{TITLE}}
		<h2 class="status_icon">{TITLE*}</h2>
	{+END}

	<form id="fp_status_form" action="#" method="post">
		{$INSERT_SPAMMER_BLACKHOLE}

		<input type="hidden" name="zone" value="{$?,{$ZONE},{$ZONE*},frontpage}" />
		<input type="hidden" name="page" value="{$PAGE*}" />

		<div class="status_controls">
			{+START,IF,{$ADDON_INSTALLED,chat}}
				<select name="privacy" size="1">
					<option selected="selected">
						{!PUBLIC}
					</option>
					<option>
						{!FRIENDS_ONLY}
					</option>
				</select>
			{+END}
			{+START,IF,{$NOT,{$ADDON_INSTALLED,chat}}}
				<input type="hidden" name="privacy" value="{!PUBLIC}" />
			{+END}
			<input onclick="disable_button_just_clicked(this);" type="submit" class="buttons__save button_screen_item" name="button" id="button" value="{!UPDATE}" />
			<p id="activities_update_notify" class="activities_update_success">254 {!activities:CHARACTERS_LEFT}</p> {$,Do not remove; the AJAX notifications are inserted here.}
		</div>

		<div class="status_box_outer">
			<label class="accessibility_hidden" for="activity_status">{!TYPE_HERE}</label>
			<textarea{+START,IF,{$NOT,{$MOBILE}}} onkeyup="manage_scroll_height(this);"{+END} class="status_box fade_input field_input_non_filled" name="status" id="activity_status" rows="2">{!TYPE_HERE}</textarea>
		</div>
	</form>
</div>

<script>//<![CDATA[
	add_event_listener_abstract(window,'load',function() {
		if ($('#fp_status_form').length!=0) {
			$('textarea','#fp_status_form').bind('focus',s_update_focus);
			$('textarea','#fp_status_form').bind('blur',s_update_blur);
			$('#fp_status_form').submit(s_update_submit);
			$('textarea','#fp_status_form').keyup(s_maintain_char_count);
			$('textarea','#fp_status_form').keypress(s_maintain_char_count);
		}
	});
//]]></script>
