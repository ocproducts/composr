<form data-tpl="installerStep4" id="form-installer-step-4" title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" autocomplete="off">
	{HIDDEN}

	<div>
		<div class="installer-main-min">
			{MESSAGE}

			{SECTIONS}
		</div>

		<p class="proceed-button">
			<button class="button-screen buttons--proceed" type="submit">{!INSTALL} Composr {+START,INCLUDE,ICON}NAME=buttons/proceed{+END}</button>
		</p>
	</div>
</form>
