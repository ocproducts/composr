<div class="wide_table_wrap">
	<table class="map_table form_table wide_table">
		{+START,IF,{$NOT,{$MOBILE}}}
			<colgroup>
				<col class="purchase_field_name_column" />
				<col class="purchase_field_input_column" />
			</colgroup>
		{+END}

		<tbody>
			{FIELDS}
		</tbody>
	</table>
</div>



TODO...

<div class="ecom_welcome box"><div class="box_inner">
	<p>{!POINTS_LEFT,{$USERNAME*,{$MEMBER},1},{POINTS_LEFT*}}</p>
</div></div>

<p>
	{!ECOM_PRODUCTS_INTRO}
</p>

<p>
	{!ECOM_PRODUCTS}
</p>

<div itemprop="significantLinks">
	{PRODUCTS}
</div>

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
