{$REQUIRE_JAVASCRIPT,galleries}
{$SET,support_mass_select,cms_galleries}

<div data-tpl="blockMainGalleryEmbed" data-tpl-params="{+START,PARAMS_JSON,carousel_id,START,MAX,block_call_url}{_*}{+END}">
	{+START,IF,{$NEQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
		{+START,IF,{$NEQ,{_GUID},carousel}}
			{$SET,ajax_block_main_gallery_embed_wrapper,ajax-block-main-gallery-embed-wrapper-{$RAND%}}
			{$SET,block_call_url,{$FACILITATE_AJAX_BLOCK_CALL,{BLOCK_PARAMS}}{+START,IF_PASSED,EXTRA_GET_PARAMS}{EXTRA_GET_PARAMS}{+END}&page={$PAGE&}}
			<div id="{$GET*,ajax_block_main_gallery_embed_wrapper}" data-ajaxify="{ callUrl: '{$GET;*,block_call_url}', callParamsFromTarget: ['^[^_]*_start$', '^[^_]*_max$'], targetsSelector: '.ajax-block-wrapper-links a, .ajax-block-wrapper-links form' }">
				<div class="gallery-grid-cell-wrap raw-ajax-grow-spot">
					{ENTRIES}
				</div>

				{+START,IF_NON_EMPTY,{PAGINATION}}
					<div class="pagination-spacing clearfix ajax-block-wrapper-links">
						{PAGINATION}
					</div>

					{+START,INCLUDE,AJAX_PAGINATION}
						WRAPPER_ID={$GET,ajax_block_main_gallery_embed_wrapper}
						ALLOW_INFINITE_SCROLL=1
					{+END}
				{+END}
			</div>
		{+END}

		{+START,IF,{$EQ,{_GUID},carousel}}
			{$REQUIRE_JAVASCRIPT,core_rich_media}
			{$REQUIRE_CSS,carousels}

			{$SET,carousel_id,{$RAND}}
			{$SET,block_call_url,{$FACILITATE_AJAX_BLOCK_CALL,{BLOCK_PARAMS},raw=.*\,cache=.*,{START_PARAM}=.*}&{START_PARAM}=current_loading_from_pos_{$GET,carousel_id}}

			<div id="carousel-{$GET*,carousel_id}" class="carousel" style="display: none" data-view="Carousel" data-view-params="{+START,PARAMS_JSON,carousel_id}{_*}{+END}">
				<div class="move-left js-btn-car-move " data-move-amount="-47">{+START,INCLUDE,ICON}NAME=carousel/button_left{+END}</div>
				<div class="main raw-ajax-grow-spot" id="carousel-{$GET*,carousel_id}-container"></div>
				<div class="move-right js-btn-car-move js-click-carousel-prepare-load-more" data-move-amount="+47">{+START,INCLUDE,ICON}NAME=carousel/button_right{+END}</div>
			</div>

			<div class="carousel-temp" id="carousel-ns-{$GET*,carousel_id}">
				{ENTRIES}
			</div>
		{+END}

		{+START,INCLUDE,MASS_SELECT_DELETE_FORM}{+END}
	{+END}

	{+START,IF,{$EQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
		{ENTRIES}

		{PAGINATION}
	{+END}

	{$SET,support_mass_select,}
</div>
