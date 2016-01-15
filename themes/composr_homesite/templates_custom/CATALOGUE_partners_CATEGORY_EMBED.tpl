{+START,IF_NON_EMPTY,{ENTRIES}}
	{ENTRIES}
{+END}

{+START,IF_EMPTY,{ENTRIES}}
	<p class="nothing_here">
		{!NO_ENTRIES}
	</p>
{+END}

{+START,IF_NON_EMPTY,{PAGINATION}}
	<div class="float_surrounder ajax_block_wrapper_links">
		{PAGINATION}
	</div>
{+END}
