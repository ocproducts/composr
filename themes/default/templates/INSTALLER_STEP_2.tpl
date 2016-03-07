<form title="{!TERMS}" class="installer_cms_licence" action="install.php" method="post">
	<div class="installer_terms_title"><label for="licence">{!TERMS}</label></div>
	<div class="constrain_field">
		<textarea readonly="readonly" class="mono_textbox wide_field" id="licence" name="licence" cols="90" rows="17">{LICENCE*}</textarea>
	</div>
</form>

<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post">
	{HIDDEN}

	<div class="float_surrounder">
		<div id="install_newsletter">
			<p class="accessibility_hidden"><label for="email">{!EMAIL_ADDRESS}</label></p>
			<div class="constrain_field">
				<input maxlength="255" class="wide_field field_input_non_filled" id="email" name="email" type="text" alt="{!EMAIL_ADDRESS}" value="{!EMAIL_ADDRESS}" size="25" onfocus="placeholder_focus(this);" onblur="placeholder_blur(this);" />
			</div>

			<p class="accessibility_hidden"><label for="interest_level">{!INST_SUBSCRIPTION_LEVEL}</label></p>
			<div class="constrain_field">
				<select class="wide_field" id="interest_level" name="interest_level">
					<option value="4">{!ONEWSLETTER_4}</option>
					<option selected="selected" value="3">{!ONEWSLETTER_3}</option>
					<option value="2">{!ONEWSLETTER_2}</option>
					<option value="1">{!ONEWSLETTER_1}</option>
				</select>
			</div>

			<p><input type="checkbox" checked="checked" value="1" name="advertise_on" id="advertise_on" /><label for="advertise_on">{!ADVERTISE_ON_COMPOSR}</label></p>
		</div>

		<p>{!EMAIL_NEWSLETTER}</p>
	 </div>

	<p class="proceed_button">
		<input class="button_screen buttons__yes" type="submit" value="{!I_AGREE}" />
	</p>
</form>
