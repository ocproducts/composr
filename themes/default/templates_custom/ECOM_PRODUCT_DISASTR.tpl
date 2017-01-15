<div class="ecom_product">
	<div class="box box___ecom_product_disastr"><div class="box_inner">
		<h2>{!DISEASES_CURES_IMMUNIZATIONS_TITLE}</h2>

		<p>
			{!DISEASES_DESCRIPTION}
		</p>

		{+START,IF_NON_EMPTY,{NEXT_URL}}
			<ul class="horizontal_links associated_links_block_group">
				<li><a title="{!ENTER}: {!DISEASES_TITLE}" href="{NEXT_URL*}">{!ENTER}</a></li>
			</ul>
		{+END}
	</div></div>
</div>
