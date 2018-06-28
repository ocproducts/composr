<p>
	{!UNINSTALL_WARNING,{$TUTORIAL_URL*,uninstall},{$TUTORIAL_URL*,tut_moving}}
</p>

<form title="{!PRIMARY_PAGE_FORM}" action="uninstall.php" method="post" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<div>
		<p class="lonely-label"><label for="given_password">{!PASSWORD}:</label></p>
		<input id="given_password" class="form-control form-control-inline" type="password" name="given_password" />
	</div>

	<p>
		<button class="btn btn-primary btn-scr admin--delete3" type="submit">{+START,INCLUDE,ICON}NAME=admin/delete3{+END} {!UNINSTALL}</button>
	</p>
</form>
