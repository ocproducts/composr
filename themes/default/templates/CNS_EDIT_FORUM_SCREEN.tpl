{TITLE}

<p>
	{!CHOOSE_FORUM_EDIT}
</p>

<form title="{!PRIMARY_PAGE_FORM}" method="post" action="{REORDER_URL*}" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	{ROOT_FORUM}

	{+START,IF_NON_EMPTY,{REORDER_URL}}
		<p class="proceed-button">
			<button accesskey="u" data-disable-on-click="1" class="button-screen buttons--proceed" type="submit">{!REORDER_FORUMS}</button>
		</p>
	{+END}
</form>

<div class="box box---edit-forum-screen"><div class="box-inner help-jumpout">
	<p>
		{!CHOOSE_FORUM_EDIT_2}
	</p>
</div></div>
