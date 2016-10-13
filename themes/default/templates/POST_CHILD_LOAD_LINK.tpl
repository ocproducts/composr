{+START,IF_PASSED,CHILDREN}{+START,IF_PASSED,OTHER_IDS}{+START,IF,{$NEQ,{OTHER_IDS},}}
	{$SET,imploded_ids,{+START,IMPLODE,\,,OTHER_IDS}{+END}}
	<p class="post_show_more" data-tpl="postChildLoadLink" data-tpl-args="{+START,PARAMS_JSON,imploded_ids,ID}{_*}{+END}">
		<a class="js-click-threaded-load-more" data-cms-js="1" href="{$SELF_URL*,0,0,0,max_comments=1000}">{+START,IF_NON_EMPTY,{CHILDREN}}{!SHOW_MORE_COMMENTS,{$NUMBER_FORMAT,{$MIN,{NUM_TO_SHOW_LIMIT},{OTHER_IDS}}}}{+END}{+START,IF_EMPTY,{CHILDREN}}{!SHOW_COMMENTS,{$NUMBER_FORMAT,{$MIN,{NUM_TO_SHOW_LIMIT},{OTHER_IDS}}}}{+END}</a>
	</p>
{+END}{+END}{+END}
