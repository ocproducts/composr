{+START,IF,{$NEQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
	{$SET,wrapper_id,ajax_block_wrapper_{$RAND%}}
	<div id="{$GET*,wrapper_id}">
		{+START,IF_NON_EMPTY,{GALLERIES}}
			<div class="box box___block_main_personal_galleries_list"><div class="box_inner compacted_subbox_stream">
				<div class="raw_ajax_grow_spot">
					{GALLERIES}
				</div>
			</div></div>
		{+END}
		{+START,IF_EMPTY,{GALLERIES}}
			<p class="nothing_here">{!NO_CATEGORIES,gallery}</p>
		{+END}

		{+START,IF_NON_EMPTY,{PAGINATION}}
			<div class="pagination_spacing float_surrounder ajax_block_wrapper_links">
				{PAGINATION}
			</div>
		{+END}

		{$,Load up the staff actions template to display staff actions uniformly (we relay our parameters to it)...}
		{+START,INCLUDE,STAFF_ACTIONS}
			1_URL={ADD_GALLERY_URL*}
			1_TITLE={!ADD_GALLERY}
			1_REDIRECT_HASH=galleries
			1_ICON=menu/_generic_admin/add_one_category
			2_URL={ADD_IMAGE_URL*}
			2_TITLE={!ADD_IMAGE}
			2_REDIRECT_HASH=galleries
			2_ICON=menu/cms/galleries/add_one_image
			3_URL={ADD_VIDEO_URL*}
			3_TITLE={!ADD_VIDEO}
			3_REDIRECT_HASH=galleries
			3_ICON=menu/cms/galleries/add_one_video
		{+END}

		{+START,IF_NON_EMPTY,{PAGINATION}}
			{+START,INCLUDE,AJAX_PAGINATION}ALLOW_INFINITE_SCROLL=1{+END}
		{+END}
	</div>
{+END}

{+START,IF,{$EQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
	{GALLERIES}

	{PAGINATION}
{+END}
