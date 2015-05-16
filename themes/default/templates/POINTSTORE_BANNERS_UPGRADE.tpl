<div class="box box___pointstore_banners_upgrade"><div class="box_inner">
	<h2>{!UPGRADE_ACCOUNT}</h2>

	<p>
		{!BANNERS_D}
	</p>

	{+START,IF_NON_EMPTY,{UPGRADE_URL}}
		<ul class="horizontal_links associated_links_block_group">
			<li><a href="{UPGRADE_URL*}">{!UPGRADE_ACCOUNT}</a></li>
		</ul>
	{+END}
</div></div>

