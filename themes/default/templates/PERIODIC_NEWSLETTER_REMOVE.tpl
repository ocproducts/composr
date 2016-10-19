{TITLE}

<p>
	{!CONFIRM_REMOVE_PERIODIC}
</p>

<form title="{!PRIMARY_PAGE_FORM}" method="post" action="{URL*}" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	{+START,IF_PASSED,HIDDEN}{HIDDEN}{+END}

	<div>
		<div class="proceed_button">
			<input class="button_screen buttons__proceed" onclick="setTimeout(function (btn) { btn.disabled=true; }, 100, this);" accesskey="u" type="submit" value="{!PROCEED}" />
		</div>
	</div>
</form>

{+START,IF,{$JS_ON}}
<a href="#!" data-cms-btn-go-back="1"><img title="{!NEXT_ITEM_BACK}" alt="{!NEXT_ITEM_BACK}" src="{$IMG*,icons/48x48/menu/_generic_admin/back}" /></a>
{+END}

