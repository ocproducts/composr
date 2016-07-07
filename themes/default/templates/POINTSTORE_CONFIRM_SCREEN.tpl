{TITLE}

<p>
	{!INFO_CONFIRM}
</p>

<div class="box box___pointstore_confirm_screen"><div class="box_inner">
	{+START,IF_NON_EMPTY,{ACTION}}
		<p>
			{ACTION}
		</p>
	{+END}

	{+START,IF_PASSED,MESSAGE}
		<p>{MESSAGE}</p>
	{+END}
</div></div>

<p>
	{!CHARGE_INFO,{COST*},{POINTS_AFTER*}}
</p>

<hr class="spaced_rule" />

<div class="box box___pointstore_confirm_screen"><div class="box_inner">
	<div class="float_surrounder">
		<div class="right">
			<form title="{!NO}" class="inline" method="post" action="{CANCEL_URL*}" autocomplete="off">
				{$INSERT_SPAMMER_BLACKHOLE}

				<div class="inline">
					<input class="button_screen buttons__no" type="submit" value="{!NO}" />
				</div>
			</form>

			<form title="{!YES}" class="inline" action="{PROCEED_URL*}" method="post" autocomplete="off">
				{$INSERT_SPAMMER_BLACKHOLE}

				<div class="inline">
					{KEEP}
					<input accesskey="u" onclick="disable_button_just_clicked(this);" class="button_screen buttons__yes" type="submit" value="{!YES}" />
				</div>
			</form>
		</div>

		<span class="vertical_alignment_buttons">{!Q_SURE}</span>
	</div>
</div></div>
