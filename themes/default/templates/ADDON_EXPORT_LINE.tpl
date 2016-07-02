<div class="float_surrounder zebra_{$CYCLE,addon_export,0,1}">
	<form title="{!EXPORT_ADDON}: {NAME*}" action="{URL*}" method="post" class="{$CYCLE*,zz,zebra_0,zebra_1}" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		<div class="right float_separation">
			<input onclick="disable_button_just_clicked(this);" class="button_screen_item menu___generic_admin__export" type="submit" title="{!EXPORT_ADDON}: {NAME*}" value="{!EXPORT_ADDON}" />
		</div>

		{FILES}

		<p>{NAME*}</p>
	</form>
</div>

