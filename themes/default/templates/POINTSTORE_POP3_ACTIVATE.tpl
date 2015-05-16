<div class="box box___pointstore_pop3_activate"><div class="box_inner">
	<h4>
		{!ACTIVATE_ACCOUNT}
	</h4>

	<p>
		{!ACTIVATE_POP3_ACCOUNT}
	</p>

	{+START,IF_NON_EMPTY,{ACTIVATE_URL}}
		<ul class="associated_links_block_group">
			<li><a href="{ACTIVATE_URL*}">{!ACTIVATE_ACCOUNT}</a></li>
		</ul>
	{+END}
</div></div>
