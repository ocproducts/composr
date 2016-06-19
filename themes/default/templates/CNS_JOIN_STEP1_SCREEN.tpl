{TITLE}

<p>
	{!DESCRIPTION_I_AGREE_RULES}
</p>

<div class="box box___cns_join_step1_screen"><div class="box_inner">
	<div class="cns_join_rules">
		{RULES}
	</div>
</div></div>

<form title="{!PRIMARY_PAGE_FORM}" class="cns_join_1" method="post" action="{URL*}" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<p>
		<input type="checkbox" id="confirm" name="confirm" value="1" onclick="document.getElementById('proceed_button').disabled=!this.checked;" /><label for="confirm">{!I_AGREE}</label>
	</p>

	{+START,IF_NON_EMPTY,{GROUP_SELECT}}
		<p>
			<label for="primary_group">{!CHOOSE_JOIN_USERGROUP}
				<select id="primary_group" name="primary_group">
					{GROUP_SELECT}
				</select>
			</label>
		</p>
	{+END}

	<p>
		{+START,IF,{$JS_ON}}
			<button onclick="disable_button_just_clicked(this); window.top.location='{$PAGE_LINK;*,:}'; return false;" class="button_screen buttons__no">{!I_DISAGREE}</button>
		{+END}

		<input accesskey="u" onclick="disable_button_just_clicked(this);" class="button_screen buttons__yes" type="submit" value="{!PROCEED}"{+START,IF,{$JS_ON}} disabled="disabled"{+END} id="proceed_button" />
	</p>
</form>

