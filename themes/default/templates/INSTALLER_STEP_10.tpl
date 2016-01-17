<div class="installer_main_min">
	<p>
		{!INSTALL_LOG_BELOW,{PREVIOUS_STEP*}}:
	</p>

	<div><div class="install_log_table">
		<p class="lonely_label">{!INSTALL_LOG}:</p>
		<nav>
			<ul class="actions_list">
				{LOG}
			</ul>
		</nav>
	</div></div>

	<p>
		{FINAL}
	</p>

	<p>
		{!FINAL_INSTRUCTIONS_B}
	</p>

	<p>
		{!FINAL_INSTRUCTIONS_C}
	</p>

	<nav class="installer_completed_calltoaction">
		<ul class="actions_list">
			<li class="actions_list_strong"><a href="{$BASE_URL*}/adminzone/index.php?page=admin_setupwizard&amp;type=browse{+START,IF,{$_GET,keep_safe_mode}}&amp;keep_safe_mode=1{+END}">{!CONFIGURE}</a> ({!RECOMMENDED})</li>
			<li><a href="{$BASE_URL*}/index.php{+START,IF,{$_GET,keep_safe_mode}}?keep_safe_mode=1{+END}">{!GO}</a></li>
		</ul>
	</nav>

	<p class="installer_done_thanks">
		<em>{!THANKS}</em>
	</p>
</div>
