{$REQUIRE_JAVASCRIPT,masonry}
{$REQUIRE_JAVASCRIPT,galleries}

{+START,IF,{$NEQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
<div data-tpl="blockMainGalleryMosaic" data-tpl-params="{+START,PARAMS_JSON,START,MAX,block_call_url}{_*}{+END}">
	{$SET,ajax_block_main_gallery_embed_wrapper,ajax-block-main-gallery-embed-wrapper-{$RAND%}}
	{$SET,block_call_url,{$FACILITATE_AJAX_BLOCK_CALL,{BLOCK_PARAMS}}{+START,IF_PASSED,EXTRA_GET_PARAMS}{EXTRA_GET_PARAMS}{+END}&page={$PAGE&}}
	<div id="{$GET*,ajax_block_main_gallery_embed_wrapper}" data-ajaxify="{ callUrl: '{$GET;*,block_call_url}', callParamsFromTarget: ['^[^_]*_start$', '^[^_]*_max$'], targetsSelector: '.ajax-block-wrapper-links a, .ajax-block-wrapper-links form' }">
		<div class="gallery-mosaic-items raw-ajax-grow-spot">
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
</div>
{+END}

{+START,IF,{$EQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
	{ENTRIES}

	{PAGINATION}
{+END}


