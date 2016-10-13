{$REQUIRE_JAVASCRIPT,ajax}
{$REQUIRE_JAVASCRIPT,checking}
{$SET,block_call_url,{$FACILITATE_AJAX_BLOCK_CALL,{BLOCK_PARAMS}}}
{$SET,wrapper_id,ajax_block_wrapper_{$RAND%}}
<div id="{$GET*,wrapper_id}" class="box_wrapper" data-tpl="blockSideShoutbox" data-tpl-args="{+START,PARAMS_JSON,wrapper_id,block_call_url}{_*}{+END}">
	<section class="box box___block_side_shoutbox"><div class="box_inner">
		<h3>{!SHOUTBOX}</h3>

		{MESSAGES}

		<form title="{!SHOUTBOX}" onsubmit="if (check_field_for_blankness(this.elements['shoutbox_message'],event)) { disable_button_just_clicked(this); return true; } return false;" target="_self" action="{URL*}" method="post" autocomplete="off">
			{$INSERT_SPAMMER_BLACKHOLE}

			<div>
				<p class="accessibility_hidden"><label for="shoutbox_message">{!MESSAGE}</label></p>
				<p class="constrain_field"><input autocomplete="off" value="" type="text" onfocus="placeholder_focus(this);" onblur="placeholder_blur(this);" id="shoutbox_message" name="shoutbox_message" alt="{!MESSAGE}" class="wide_field field_input_non_filled" /></p>
			</div>

			<p class="proceed_button">
				<input type="submit" value="{!SEND_MESSAGE}" class="button_screen_item buttons__send" />
			</p>
		</form>
	</div></section>
</div>
