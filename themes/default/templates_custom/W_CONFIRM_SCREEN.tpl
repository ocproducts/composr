{TITLE}

<p>{!Q_SURE}</p>

<form method="post" enctype="multipart/form-data" action="{URL*}" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<input type="hidden" name="type" value="{COMMAND*}" />
	<input type="hidden" name="item" value="{ITEM*}" />
	<input type="hidden" name="member" value="{MEMBER*}" />
	<input type="hidden" name="param" value="{PARAM*}" />

	<p class="proceed_button">
		<input class="button_screen buttons__proceed" type="submit" value="{!PROCEED}" />
	</p>
</form>
