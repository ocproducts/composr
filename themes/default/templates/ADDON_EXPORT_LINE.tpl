<div class="float-surrounder zebra-{$CYCLE,addon_export,0,1}">
	<form title="{!EXPORT_ADDON}: {NAME*}" action="{URL*}" method="post" class="{$CYCLE*,zz,zebra-0,zebra-1}" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		<div class="right float-separation">
			<input data-disable-on-click="1" class="button-screen-item menu---generic-admin--export" type="submit" title="{!EXPORT_ADDON}: {NAME*}" value="{!EXPORT_ADDON}" />
		</div>

		{FILES}

		<p>{NAME*}</p>
	</form>
</div>
