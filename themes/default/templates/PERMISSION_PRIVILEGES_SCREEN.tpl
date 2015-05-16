{TITLE}

<form title="{!PRIMARY_PAGE_FORM}" method="post" action="{URL*}">
	{$INSERT_SPAMMER_BLACKHOLE}

	<div>
		{SECTIONS}

		<p class="proceed_button">
			<input accesskey="u" onclick="disable_button_just_clicked(this);" class="buttons__save button_screen" type="submit" value="{!SAVE}" />
		</p>
	</div>
</form>

