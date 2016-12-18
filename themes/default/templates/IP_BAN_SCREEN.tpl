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
	<div>
		<textarea{+START,IF,{$DESKTOP}} onkeyup="manage_scroll_height(this);"{+END} cols="30" rows="14" class="wide_field textarea_scroll" id="bans" name="bans">{BANS*}</textarea>
	</div>

	<p class="lonely_label"><label for="locked_bans">{!EXTERNALLY_BANNED_ADDRESSES}:</label></p>
	<div>
		<textarea readonly="readonly" cols="30" rows="14" class="wide_field textarea_scroll" id="locked_bans" name="locked_bans">{LOCKED_BANS*}</textarea>
	</div>

	<p class="lonely_label"><label for="unbannable">{!UNBANNABLE_IP_ADDRESSES}:</label></p>
	<div>
		<textarea cols="30" rows="14" class="wide_field textarea_scroll" id="unbannable" name="unbannable">{UNBANNABLE*}</textarea>
	</div>

	<p class="proceed_button">
		<input accesskey="u" onclick="disable_button_just_clicked(this);" class="button_screen buttons__save" type="submit" value="{!SAVE}" />
	</p>
</form>

<script>// <![CDATA[
	manage_scroll_height(document.getElementById('bans'));
//]]></script>
