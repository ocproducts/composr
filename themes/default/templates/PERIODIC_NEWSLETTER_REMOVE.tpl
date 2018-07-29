{$REQUIRE_JAVASCRIPT,newsletter}

<div data-tpl="periodicNewsletterRemove">
	{TITLE}

	<p>
		{!CONFIRM_REMOVE_PERIODIC}
	</p>

	<form title="{!PRIMARY_PAGE_FORM}" method="post" action="{URL*}" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		{+START,IF_PASSED,HIDDEN}{HIDDEN}{+END}

		<div>
			<div class="proceed-button">
				<button class="button-screen buttons--proceed js-click-btn-disable-self" accesskey="u" type="submit">{+START,INCLUDE,ICON}NAME=buttons/proceed{+END} {!PROCEED}</button>
			</div>
		</div>
	</form>

	<a href="#!" data-cms-btn-go-back="1" title="{!NEXT_ITEM_BACK}">
		{+START,INCLUDE,ICON}
			NAME=admin/back
			ICON_SIZE=48
		{+END}
	</a>
</div>
