{TITLE}

<p>
	{!ECOM_PRODUCTS_LOG_TEXT}
</p>

<div class="float_surrounder">
	{CONTENT}

	{+START,IF_NON_EMPTY,{PAGINATION}}
		<div class="pagination_spacing float_surrounder ajax_block_wrapper_links">
			{PAGINATION}
		</div>
	{+END}
</div>
