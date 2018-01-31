{TITLE}

{$REQUIRE_CSS,messages}

<div class="site-special-message ssm-inform" role="alert">
	<div class="site-special-message-inner">
		<div class="box box---inform-screen"><div class="box-inner">
			{TEXT*}
		</div></div>
	</div>
</div>

{+START,IF_PASSED,BACK_URL}
<form class="back-button" title="{!NEXT_ITEM_BACK}" action="{BACK_URL*}" method="post" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<div>
		{+START,IF_PASSED,FIELDS}{FIELDS}{+END}
		<button class="button-icon" type="submit"><img title="{!NEXT_ITEM_BACK}" alt="{!NEXT_ITEM_BACK}" width="48" height="48" src="{$IMG*,icons/admin/back}" /></button>
	</div>
</form>
{+END}
