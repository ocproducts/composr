{TITLE}

<p>
	{!LDAP_INTRO}
</p>

<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<div>
		<p>
			{!LDAP_SYNC_GROUPS_ADD}
		</p>

		<div class="standard_indent">
			{GROUPS_ADD}
			{+START,IF_EMPTY,{GROUPS_ADD}}
				<p class="nothing_here">{!NONE}</p>
			{+END}
		</div>
	</div>

	<div>
		<p>
			{!LDAP_SYNC_GROUPS_DELETE}
		</p>

		<div class="standard_indent">
			{GROUPS_DELETE}
			{+START,IF_EMPTY,{GROUPS_DELETE}}
				<p class="nothing_here">{!NONE}</p>
			{+END}
		</div>
	</div>

	<div>
		<p>
			{!LDAP_SYNC_MEMBERS_DELETE}
		</p>

		<div class="standard_indent">
			{MEMBERS_DELETE}
			{+START,IF_EMPTY,{MEMBERS_DELETE}}
				<p class="nothing_here">{!NONE}</p>
			{+END}
		</div>
	</div>

	<p class="proceed_button">
		<input accesskey="u" data-disable-on-click="1" class="button_screen buttons__save" type="submit" value="{!SAVE}" />
	</p>
</form>
