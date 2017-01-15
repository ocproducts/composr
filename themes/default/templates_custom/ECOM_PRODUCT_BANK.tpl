<div class="ecom_product">
	<div class="box box___ecom_product_bank"><div class="box_inner">
		<h2>{!BANKING}</h2>

		<p>
			{!BANK_DESCRIPTION}
		</p>

		{+START,IF_NON_EMPTY,{NEXT_URL}}
			<ul class="horizontal_links associated_links_block_group">
				<li><a title="{!ENTER}: {!GAMBLING}" href="{NEXT_URL*}">{!ENTER}</a></li>
			</ul>
		{+END}
	</div></div>
</div>
