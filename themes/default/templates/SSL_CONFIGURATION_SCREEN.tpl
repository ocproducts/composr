{TITLE}

<p>
	{!SSL_PAGE_SELECT}
</p>

<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<div class="float_surrounder">
		{+START,LOOP,ENTRIES}
			<div class="float_surrounder vertical_alignment">
				<label for="ssl_{ZONE*}__{PAGE*}">
					<input type="checkbox" value="1" id="ssl_{ZONE*}__{PAGE*}" name="ssl_{ZONE*}__{PAGE*}"{+START,IF,{TICKED}} checked="checked"{+END} />
					<kbd>{ZONE*}:{PAGE*}</kbd>
				</label>
			</div>
		{+END}
	</div>

	<p class="proceed_button">
		<input accesskey="u" onclick="disable_button_just_clicked(this);" class="button_screen buttons__save" type="submit" value="{!SAVE}" />
	</p>
</form>

