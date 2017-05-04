{+START,IF,{$NEQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
	{$SET,ajax_block_main_cns_involved_topics_wrapper,ajax_block_main_cns_involved_topics_wrapper_{$RAND%}}
	<div id="{$GET*,ajax_block_main_cns_involved_topics_wrapper}">
		{+START,IF_NON_EMPTY,{TOPICS}}
			{TOPICS}
		{+END}
		{+START,IF_EMPTY,{TOPICS}}
			<p class="nothing_here">{!NO_ENTRIES,topic}</p>
		{+END}

		{+START,INCLUDE,AJAX_PAGINATION}ALLOW_INFINITE_SCROLL=1{+END}
	</div>
{+END}

{+START,IF,{$EQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
	{TOPICS}
{+END}
