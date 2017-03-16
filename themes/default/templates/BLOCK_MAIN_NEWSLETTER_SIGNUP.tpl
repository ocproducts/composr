{+START,IF_PASSED,MSG}
	<p>
		{MSG}
	</p>
{+END}

<section class="box box___block_main_newsletter_signup"><div class="box_inner">
	<h3>{!NEWSLETTER}{$?,{$NEQ,{NEWSLETTER_TITLE},{!GENERAL}},: {NEWSLETTER_TITLE*}}</h3>

	<form title="{!NEWSLETTER}" onsubmit="if (!check_field_for_blankness(this.elements['address{NID;*}'],event)) return false; if (!this.elements['address{NID*}'].value.match(/^[a-zA-Z0-9\._\-\+]+@[a-zA-Z0-9\._\-]+$/)) { window.fauxmodal_alert('{!javascript:NOT_A_EMAIL;=*}'); return false; } disable_button_just_clicked(this); return true;" action="{URL*}" method="post" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		<p class="accessibility_hidden"><label for="baddress">{!EMAIL_ADDRESS}</label></p>

		<div class="constrain_field">
			<input class="wide_field field_input_non_filled" id="baddress" name="address{NID*}" onfocus="placeholder_focus(this);" onblur="placeholder_blur(this);" alt="{!EMAIL_ADDRESS}" value="{!EMAIL_ADDRESS}" />
		</div>

		<p class="proceed_button">
			<input class="button_screen_item menu__site_meta__newsletters" type="submit" value="{!SUBSCRIBE}" />
		</p>
	</form>
</div></section>
