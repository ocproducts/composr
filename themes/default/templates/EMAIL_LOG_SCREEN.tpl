{TITLE}

{RESULTS_TABLE}

<div class="buttons_group">
	<form title="{!DELETE_ALL}" class="right" action="{MASS_DELETE_URL*}" method="post">
		{$INSERT_SPAMMER_BLACKHOLE}

		<div class="inline">
			<input class="menu___generic_admin__delete button_screen" type="submit" value="{!DELETE_ALL}" />
		</div>
	</form>
	<form title="{!SEND_ALL}" class="right" action="{MASS_SEND_URL*}" method="post">
		{$INSERT_SPAMMER_BLACKHOLE}

		<div class="inline">
			<input class="buttons__send button_screen" type="submit" value="{!SEND_ALL}" />
		</div>
	</form>
</div>
