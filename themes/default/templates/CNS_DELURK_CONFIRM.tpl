{TITLE}

<form title="{!PRIMARY_PAGE_FORM}" method="post" action="{URL*}" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<p class="lonely_label">
		{!DELURK_CONFIRM}
	</p>
	<ul>
		{+START,LOOP,LURKERS}
			<li>
				<label for="lurker_{ID*}"><input type="checkbox" name="lurker_{ID*}" id="lurker_{ID*}" value="1" checked="checked" /> <a title="{USERNAME*} {!LINK_NEW_WINDOW}" target="_blank" href="{PROFILE_URL*}">{USERNAME*}</a></label>
			</li>
		{+END}
	</ul>

	<p class="proceed_button">
		{+START,IF,{$JS_ON}}
			<input class="button_screen buttons__back" type="button" onclick="history.back(); return false;" value="{!GO_BACK}" />
		{+END}

		<input accesskey="u" data-disable-after-click="1" class="button_screen buttons__proceed" type="submit" value="{!PROCEED}" />
	</p>
</form>
