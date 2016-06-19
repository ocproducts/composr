{TITLE}

{$REQUIRE_CSS,messages}

<div class="site_special_message ssm_inform" role="alert">
	<div class="site_special_message_inner">
		<div class="box box___inform_screen"><div class="box_inner">
			{TEXT*}
		</div></div>
	</div>
</div>

{+START,IF_PASSED,BACK_URL}
	<form class="back_button" title="{!NEXT_ITEM_BACK}" action="{BACK_URL*}" method="post" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		<div>
			{+START,IF_PASSED,FIELDS}{FIELDS}{+END}
			<button class="button_icon" type="submit"><img title="{!NEXT_ITEM_BACK}" alt="{!NEXT_ITEM_BACK}" src="{$IMG*,icons/48x48/menu/_generic_admin/back}" /></button>
		</div>
	</form>
{+END}
