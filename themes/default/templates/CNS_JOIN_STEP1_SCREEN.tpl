{$REQUIRE_JAVASCRIPT,core_cns}
<div data-tpl="cnsJoinStep1Screen">
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
		<input type="checkbox" id="confirm" name="confirm" value="1" class="js-chb-click-toggle-proceed-btn" /><label for="confirm">{!I_AGREE}</label>
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
		<button type="button" data-disable-on-click="1" onclick="window.top.location='{$PAGE_LINK;*,:}';" class="button_screen buttons__no">{!I_DISAGREE}</button>

		<input accesskey="u" data-disable-on-click="1" class="button_screen buttons__yes" type="submit" value="{!PROCEED}" disabled="disabled" id="proceed_button" />
	</p>
</form>
</div>