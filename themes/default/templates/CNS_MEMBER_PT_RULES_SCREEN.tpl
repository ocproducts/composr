{TITLE}

<p>
	{!PT_RULES_PAGE_INTRO,{$DISPLAYED_USERNAME*,{USERNAME}}}
</p>

<div class="box box---cns-member-pt-rules-screen"><div class="box-inner">
	{RULES}
</div></div>

<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<p class="proceed-button">
		<button accesskey="u" data-disable-on-click="1" class="button-screen buttons--proceed" type="submit">{!PROCEED}</button>
	</p>
</form>
