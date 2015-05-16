<div class="global_middle">
	<form title="{!PRIMARY_PAGE_FORM}" method="post" action="{URL*}">
		<label for="member_id">{!ATTACHMENTS_OF}:
		<select id="member_id" name="member_id">
			{LIST}
		</select></label>

		<input onclick="disable_button_just_clicked(this);" class="buttons__proceed button_screen_item" type="submit" value="{!PROCEED}" />
	</form>

	<hr class="spaced_rule" />

	{CONTENT}
	{+START,IF_EMPTY,{CONTENT}}
		<p class="nothing_here">
			{!NO_ENTRIES}
		</p>
	{+END}
</div>
