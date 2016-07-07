{TITLE}

{WARNINGS}

{+START,IF_NON_EMPTY,{INSTALL_FILES}}
	<p class="lonely_label">{!ADDON_FILES}:</p>
	<ul>
		{INSTALL_FILES}
	</ul>
{+END}

{+START,IF_NON_EMPTY,{UNINSTALL_FILES}}
	<p>{!WARNING_UNINSTALL_GENERAL}</p>

	<p>{!WARNING_UNINSTALL}</p>

	<ul>
		{UNINSTALL_FILES}
	</ul>
{+END}

<div class="float_surrounder">
	<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		{HIDDEN}

		<p class="proceed_button">
			{+START,IF,{$JS_ON}}
				<input class="button_screen buttons__back" type="button" onclick="history.back(); return false;" value="{!GO_BACK}" />
			{+END}

			<input onclick="disable_button_just_clicked(this);" class="button_screen buttons__proceed" type="submit" value="{!PROCEED}" />
		</p>
	</form>
</div>
