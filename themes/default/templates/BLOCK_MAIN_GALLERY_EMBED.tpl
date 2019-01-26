{$REQUIRE_JAVASCRIPT,galleries}
{$SET,support_mass_select,cms_galleries}

{+START,IF,{$NEQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
<div data-tpl="blockMainGalleryEmbed" data-tpl-params="{+START,PARAMS_JSON,carousel_id,START,MAX,block_call_url}{_*}{+END}">
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

	{+START,INCLUDE,MASS_SELECT_DELETE_FORM}{+END}
</div>
{+END}

{+START,IF,{$EQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
	{ENTRIES}

	{PAGINATION}
{+END}

{$SET,support_mass_select,}

