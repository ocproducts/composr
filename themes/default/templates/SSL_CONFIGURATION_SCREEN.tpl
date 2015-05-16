{TITLE}

<p>
	{!SSL_PAGE_SELECT}
</p>

<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post">
	{$INSERT_SPAMMER_BLACKHOLE}

	<div class="float_surrounder">
		{CONTENT}
	</div>

	<p class="proceed_button">
		<input accesskey="u" onclick="disable_button_just_clicked(this);" class="buttons__save button_screen" type="submit" value="{!SAVE}" />
	</p>
</form>

