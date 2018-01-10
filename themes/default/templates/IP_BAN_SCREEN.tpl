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

		<p class="lonely-label"><label for="bans">{!BANNED_ADDRESSES}:</label></p>
		<div>
			<textarea cols="30" rows="14" class="wide-field textarea-scroll" id="bans" name="bans">{BANS*}</textarea>
		</div>

		<p class="lonely-label"><label for="locked_bans">{!EXTERNALLY_BANNED_ADDRESSES}:</label></p>
		<div>
			<textarea readonly="readonly" cols="30" rows="14" class="wide-field textarea-scroll" id="locked_bans" name="locked_bans">{LOCKED_BANS*}</textarea>
		</div>

		<p class="lonely-label"><label for="unbannable">{!UNBANNABLE_IP_ADDRESSES}:</label></p>
		<div>
			<textarea cols="30" rows="14" class="wide-field textarea-scroll" id="unbannable" name="unbannable">{UNBANNABLE*}</textarea>
		</div>

		<p class="proceed_button">
			<input accesskey="u" data-disable-on-click="1" class="button-screen buttons--save" type="submit" value="{!SAVE}" />
		</p>
	</form>
</div>
