{$REQUIRE_JAVASCRIPT,core_notifications}

<div data-tpl="notificationsManageScreen">
	{TITLE}

	<form title="{!NOTIFICATIONS}" method="post" action="{ACTION_URL*}" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		<div>
			{INTERFACE}

			<p class="proceed-button">
				<button type="submit" class="btn btn-primary btn-scr buttons--save">{+START,INCLUDE,ICON}NAME=buttons/save{+END} {!SAVE}</button>
			</p>
		</div>
	</form>
</div>
