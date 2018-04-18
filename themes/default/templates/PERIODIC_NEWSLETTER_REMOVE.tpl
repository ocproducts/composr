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
				<button class="button-screen buttons--proceed js-click-btn-disable-self" accesskey="u" type="submit">{!PROCEED} {+START,INCLUDE,ICON}NAME=buttons/proceed{+END}</button>
			</div>
		</div>
	</form>

	<a href="#!" data-cms-btn-go-back="1"><img title="{!NEXT_ITEM_BACK}" alt="{!NEXT_ITEM_BACK}" width="48" height="48" src="{$IMG*,icons/admin/back}" /></a>
</div>
