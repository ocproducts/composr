<div class="global_middle" data-view="AttachmentsBrowser" data-view-params="{+START,PARAMS_JSON,FIELD_NAME,ID,DESCRIPTION}{_*}{+END}">
	<form title="{!PRIMARY_PAGE_FORM}" method="post" action="{URL*}" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		<label for="member_id">{!ATTACHMENTS_OF}:
		<select id="member_id" name="member_id">
			{LIST}
		</select></label>

		<input data-disable-on-click="1" class="button_screen_item buttons__proceed" type="submit" value="{!PROCEED}" />
	</form>

	<hr class="spaced_rule" />

	{+START,LOOP,ATTACHMENTS}
		{TPL}

		<div class="buttons_group">
			<a class="button_screen_item buttons__choose js-click-do-attachment-and-close" href="#!"><span>{!CHOOSE}</span></a>

			{+START,IF,{MAY_DELETE}}
				<form title="{!DELETE}" class="inline" method="post" action="{DELETE_URL*}" autocomplete="off">
					{$INSERT_SPAMMER_BLACKHOLE}

					<input type="hidden" name="delete_{ID*}" value="1" />
					<input data-cms-confirm-click="{!ARE_YOU_SURE_DELETE*}" type="submit" class="button_screen_item menu___generic_admin__delete" value="{!DELETE}" />
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
