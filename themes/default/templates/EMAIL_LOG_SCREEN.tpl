{TITLE}

{RESULTS_TABLE}

<div class="buttons_group">
	<form title="{!DELETE_ALL}" class="right" action="{MASS_DELETE_URL*}" method="post" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		<div class="inline">
			<input class="button_screen menu___generic_admin__delete" type="submit" value="{!DELETE_ALL}" />
		</div>
	</form>
	<form title="{!SEND_ALL}" class="right" action="{MASS_SEND_URL*}" method="post" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		<div class="inline">
			<input class="button_screen buttons__send" type="submit" value="{!SEND_ALL}" />
		</div>
	</form>
</div>
