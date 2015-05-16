{TITLE}

<p>
	{!PT_RULES_PAGE_INTRO,{$DISPLAYED_USERNAME*,{USERNAME}}}
</p>

<div class="box box___cns_member_pt_rules_screen"><div class="box_inner">
	{RULES}
</div></div>

<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post">
	{$INSERT_SPAMMER_BLACKHOLE}

	<p class="proceed_button">
		 <input accesskey="u" onclick="disable_button_just_clicked(this);" class="buttons__proceed button_screen" type="submit" value="{!PROCEED}" />
	</p>
</form>

