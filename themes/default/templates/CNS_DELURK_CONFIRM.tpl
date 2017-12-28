{TITLE}

<form title="{!PRIMARY_PAGE_FORM}" method="post" action="{URL*}" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<p class="lonely-label">
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
		<input class="button_screen buttons--back" type="button" data-cms-btn-go-back="1" value="{!GO_BACK}" />

		<input accesskey="u" data-disable-on-click="1" class="button_screen buttons--proceed" type="submit" value="{!PROCEED}" />
	</p>
</form>
