<div class="float_surrounder zebra_{$CYCLE,addon_export,0,1}">
	<form title="{!EXPORT_ADDON}: {NAME*}" action="{URL*}" method="post" class="{$CYCLE*,zz,zebra_0,zebra_1}">
		<div class="right float_separation">
			<input onclick="disable_button_just_clicked(this);" class="menu___generic_admin__export button_screen_item" type="submit" title="{!EXPORT_ADDON}: {NAME*}" value="{!EXPORT_ADDON}" />
		</div>

		{FILES}

		<p><kbd>{NAME*}</kbd></p>
	</form>
</div>

