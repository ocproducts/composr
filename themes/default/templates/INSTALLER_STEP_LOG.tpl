<div data-tpl="installerStepLog">
	<p>
		{!INSTALL_LOG_BELOW,{CURRENT_STEP*}}:
	</p>
	
	<div class="actions-list installer_main_min">
		<div class="install_log_table">
			<p class="lonely-label">{!INSTALL_LOG}:</p>
			<ul>
				{LOG}
			</ul>
		</div>
	</div>
	
	<form title="{!PRIMARY_PAGE_FORM}" action="{URL*}" method="post" autocomplete="off">
		<div>
			{HIDDEN}
	
			<p class="proceed-button">
				<input id="proceed-button" class="button-screen buttons--proceed" type="submit" value="{!PROCEED}" />
			</p>
		</div>
	</form>
</div>
