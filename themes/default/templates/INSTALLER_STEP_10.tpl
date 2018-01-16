<div class="installer-main-min">
	<p>
		{!INSTALL_LOG_BELOW,{CURRENT_STEP*}}:
	</p>

	<div><div class="install-log-table">
		<p class="lonely-label">{!INSTALL_LOG}:</p>
		<nav>
			<ul class="actions-list">
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

	<nav class="installer-completed-calltoaction">
		<ul class="actions-list">
			<li class="actions-list-strong"><a href="{$BASE_URL*}/adminzone/index.php?page=admin_setupwizard&amp;type=browse{+START,IF,{$_GET,keep_safe_mode}}&amp;keep_safe_mode=1{+END}&amp;came_from_installer=1">{!CONFIGURE}</a> ({!RECOMMENDED})</li>
			<li><a href="{$BASE_URL*}/index.php?came_from_installer=1{+START,IF,{$_GET,keep_safe_mode}}&amp;keep_safe_mode=1{+END}">{!GO}</a></li>
		</ul>
	</nav>

	<p class="installer-done-thanks">
		<em>{!THANKS}</em>
	</p>
</div>
