<div class="ecom_product">
	<div class="box box___ecom_product_giftr"><div class="box_inner">
		<h2>{!GIFTR_TITLE}</h2>

		<p>
			{!GIFTS_DESCRIPTION}
		</p>

		{+START,IF_NON_EMPTY,{NEXT_URL}}
			<ul class="horizontal_links associated_links_block_group">
				<li><a title="{!ENTER}: {!GIFTR_TITLE}" href="{NEXT_URL*}">{!ENTER}</a></li>
			</ul>
		{+END}
	</div></div>
</div>
