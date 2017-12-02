{$REQUIRE_JAVASCRIPT,galleries}
{$SET,support_mass_select,cms_galleries}

<div data-tpl="blockMainGalleryEmbed" data-tpl-params="{+START,PARAMS_JSON,carousel_id,START,MAX,block_call_url}{_*}{+END}">
	{+START,IF,{$NEQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
		{+START,IF,{$NEQ,{_GUID},carousel}}
			{$SET,ajax_block_main_gallery_embed_wrapper,ajax_block_main_gallery_embed_wrapper_{$RAND%}}
			<div id="{$GET*,ajax_block_main_gallery_embed_wrapper}">
				<div class="gallery_grid_cell_wrap raw_ajax_grow_spot">
					{ENTRIES}
				</div>

				{+START,IF_NON_EMPTY,{PAGINATION}}
					<div class="pagination_spacing float-surrounder ajax_block_wrapper_links">
						{PAGINATION}
					</div>

					{+START,INCLUDE,AJAX_PAGINATION}ALLOW_INFINITE_SCROLL=1{+END}
				{+END}
			</div>
		{+END}

		{+START,IF,{$EQ,{_GUID},carousel}}
			{$REQUIRE_JAVASCRIPT,core_rich_media}
			{$REQUIRE_CSS,carousels}

			{$SET,carousel_id,{$RAND}}
			{$SET,block_call_url,{$FACILITATE_AJAX_BLOCK_CALL,{BLOCK_PARAMS},raw=.*\,cache=.*,{START_PARAM}=.*}&{START_PARAM}=current_loading_from_pos_{$GET,carousel_id}}

			<div id="carousel_{$GET*,carousel_id}" class="carousel" style="display: none" data-view="Carousel" data-view-params="{+START,PARAMS_JSON,carousel_id}{_*}{+END}">
				<div class="move-left js-btn-car-move " data-move-amount="-47"></div>
				<div class="move-right js-btn-car-move js-click-carousel-prepare-load-more" data-move-amount="+47"></div>

				<div class="main raw_ajax_grow_spot" id="carousel_{$GET*,carousel_id}_container"></div>
			</div>

			<div class="carousel-temp" id="carousel_ns_{$GET*,carousel_id}">
				{ENTRIES}
			</div>
		{+END}

		{+START,INCLUDE,MASS_SELECT_DELETE_FORM}
		{+END}
	{+END}

	{+START,IF,{$EQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
		{ENTRIES}

		{PAGINATION}
	{+END}

	{$SET,support_mass_select,}
</div>
