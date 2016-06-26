<p>
	{!UNINSTALL_WARNING,{$TUTORIAL_URL*,uninstall},{$TUTORIAL_URL*,tut_moving}}
</p>

<form title="{!PRIMARY_PAGE_FORM}" action="uninstall.php" method="post" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<div>
		<p class="lonely_label"><label for="given_password">{!PASSWORD}:</label></p>
		<input id="given_password" type="password" name="given_password" />
	</div>

	<p>
		<input class="button_screen menu___generic_admin__delete" type="submit" value="{!UNINSTALL}" />
	</p>
</form>

