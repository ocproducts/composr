<div class="ecom_product">
	<div class="box box___ecom_product_banners_2"><div class="box_inner">
		<h2>{!BANNER_ADS}</h2>

		<p>
			{!BANNER_DESCRIPTION,{$SITE_NAME*}}
		</p>

		{+START,IF_NON_EMPTY,{BANNER_URL}}
			<ul class="horizontal_links associated_links_block_group">
				<li><a title="{!ENTER}: {!BANNER_ADS}" href="{BANNER_URL*}">{!ENTER}</a></li>
			</ul>
		{+END}
	</div></div>
</div>
