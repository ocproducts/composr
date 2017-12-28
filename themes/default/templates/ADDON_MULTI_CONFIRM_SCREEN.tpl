{TITLE}

{WARNINGS}

{+START,IF_NON_EMPTY,{INSTALL_FILES}}
	<p class="lonely-label">{!ADDON_FILES}:</p>
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

<div class="float-surrounder">
	<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		{HIDDEN}

		<p class="proceed_button">
			<input class="button_screen buttons--back" type="button" data-cms-btn-go-back="1" value="{!GO_BACK}" />

			<input data-disable-on-click="1" class="button_screen buttons--proceed" type="submit" value="{!PROCEED}" />
		</p>
	</form>
</div>
