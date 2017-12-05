<form title="{!TERMS}" class="installer_cms_licence" action="install.php" method="post" autocomplete="off">
	<div class="installer_terms_title"><label for="licence">{!TERMS}</label></div>
	<div>
		<textarea readonly="readonly" class="mono_textbox wide_field" id="licence" name="licence" cols="90" rows="17">{LICENCE*}</textarea>
	</div>
</form>

<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" autocomplete="off">
	{HIDDEN}

	<div class="float-surrounder">
		<div id="install_newsletter">
			<p class="accessibility_hidden"><label for="email">{!EMAIL_ADDRESS}</label></p>
			<div>
				<input maxlength="255" class="wide_field" id="email" name="email" type="text" alt="{!EMAIL_ADDRESS}" placeholder="{!EMAIL_ADDRESS_FOR_NEWSLETTER}" size="25" />
			</div>

			<p><input type="checkbox" checked="checked" value="1" name="advertise_on" id="advertise_on" /><label for="advertise_on">{!ADVERTISE_ON_COMPOSR}</label></p>
		</div>

		<p>{!EMAIL_NEWSLETTER}</p>
	</div>

	<p class="proceed_button">
		<input class="button_screen buttons--yes" data-disable-on-click="1" type="submit" value="{!I_AGREE}" />
	</p>
</form>
