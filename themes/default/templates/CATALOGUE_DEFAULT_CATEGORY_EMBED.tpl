{+START,IF,{$NEQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
	{$SET,wrapper_id,ajax_block_wrapper_{$RAND%}}
	<div id="{$GET*,wrapper_id}" class="box_wrapper">
		{+START,SET,sorting}
			{$SET,show_sort_button,1}
			{+START,IF_NON_EMPTY,{SORTING}}
				<div class="box category_sorter inline_block"><div class="box_inner">
					{SORTING}
				</div></div>
			{+END}
		{+END}

		{+START,IF,{$CONFIG_OPTION,infinite_scrolling}}
			{$GET,sorting}
		{+END}

		{+START,IF_NON_EMPTY,{ENTRIES}}
			<div class="float_surrounder display_type_{DISPLAY_TYPE*} raw_ajax_grow_spot">
				{ENTRIES}
			</div>
		{+END}

		{+START,IF_EMPTY,{ENTRIES}}
			<p class="nothing_here">
				{!NO_ENTRIES,catalogue_entry}
			</p>
		{+END}

		{+START,IF,{$NOT,{$CONFIG_OPTION,infinite_scrolling}}}
			{$GET,sorting}
		{+END}

		{+START,IF_NON_EMPTY,{PAGINATION}}
			<div class="pagination_spacing float_surrounder ajax_block_wrapper_links">
				{PAGINATION}
			</div>

			{+START,INCLUDE,AJAX_PAGINATION}
				ALLOW_INFINITE_SCROLL={$EQ,{DISPLAY_TYPE},FIELDMAPS,GRID}
			{+END}
		{+END}
	</div>
{+END}

{+START,IF,{$EQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
	{ENTRIES}

	{PAGINATION}
{+END}
