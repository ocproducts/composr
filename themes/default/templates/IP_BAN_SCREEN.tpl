<div data-tpl="ipBanScreen">
	{TITLE}

	{+START,INCLUDE,HANDLE_CONFLICT_RESOLUTION}{+END}

	<p>
		{!DESCRIPTION_BANNED_ADDRESSES_A}
	</p>

	<p>
		{!DESCRIPTION_BANNED_ADDRESSES_B}
	</p>

	<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		<p class="lonely_label"><label for="bans">{!BANNED_ADDRESSES}:</label></p>
		<div class="constrain_field">
			<textarea cols="30" rows="14" class="wide_field" id="bans" name="bans" wrap="off">{BANS*}</textarea>
		</div>

		<p class="lonely_label"><label for="locked_bans">{!EXTERNALLY_BANNED_ADDRESSES}:</label></p>
		<div class="constrain_field">
			<textarea readonly="readonly" cols="30" rows="14" class="wide_field" id="locked_bans" name="locked_bans" wrap="off">{LOCKED_BANS*}</textarea>
		</div>

		<p class="lonely_label"><label for="unbannable">{!UNBANNABLE_IP_ADDRESSES}:</label></p>
		<div class="constrain_field">
			<textarea cols="30" rows="14" class="wide_field" id="unbannable" name="unbannable" wrap="off">{UNBANNABLE*}</textarea>
		</div>

		<p class="proceed_button">
			<input accesskey="u" data-disable-on-click="1" class="button_screen buttons__save" type="submit" value="{!SAVE}" />
		</p>
	</form>
</div>
