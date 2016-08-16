{TITLE}

{CHAT_SOUND}

<p data-cms-call="prepare_chat_sounds">
	{!CHOOSE_SOUND_EFFECTS}
</p>

<form class="chat_set_effects" title="{!PRIMARY_PAGE_FORM}" action="{POST_URL*}" method="post" enctype="multipart/form-data" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	{HIDDEN}

	<div>
		{SETTING_BLOCKS}

		{+START,INCLUDE,FORM_STANDARD_END}{+END}
	</div>
</form>
