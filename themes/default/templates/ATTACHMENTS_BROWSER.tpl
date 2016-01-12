<div class="global_middle">
	<form title="{!PRIMARY_PAGE_FORM}" method="post" action="{URL*}">
		<label for="member_id">{!ATTACHMENTS_OF}:
		<select id="member_id" name="member_id">
			{LIST}
		</select></label>

		<input onclick="disable_button_just_clicked(this);" class="buttons__proceed button_screen_item" type="submit" value="{!PROCEED}" />
	</form>

	<hr class="spaced_rule" />

	{+START,LOOP,ATTACHMENTS}
		{TPL}

		<div class="buttons_group">
			<a class="buttons__choose button_screen_item" onclick="do_attachment('{FIELD_NAME;*}','{ID;*}','{DESCRIPTION;*}'); if (typeof window.faux_close!='undefined') faux_close(); else window.close(); return false;" href="#"><span>{!CHOOSE}</span></a>

			{+START,IF,{MAY_DELETE}}
				<form title="{!DELETE}" class="inline" method="post" action="{DELETE_URL*}">
					{$INSERT_SPAMMER_BLACKHOLE}

					<input type="hidden" name="delete_{ID*}" value="1" />
					<input onclick="var form=this.form; fauxmodal_confirm('{!ARE_YOU_SURE_DELETE;*}',function(v) { if (v) form.submit(); }); return false;" type="submit" class="menu___generic_admin__delete button_screen_item" value="{!DELETE}" />
				</form>
			{+END}
		</div>

		<hr class="spaced_rule" />
	{+END}
	{+START,IF_EMPTY,{ATTACHMENTS}}
		<p class="nothing_here">
			{!NO_ENTRIES}
		</p>
	{+END}
</div>
