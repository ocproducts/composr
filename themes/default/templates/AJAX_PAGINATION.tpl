{$REQUIRE_JAVASCRIPT,core_abstract_interfaces}

{$SET,block_call_url,{$FACILITATE_AJAX_BLOCK_CALL,{BLOCK_PARAMS}}{+START,IF_PASSED,EXTRA_GET_PARAMS}{EXTRA_GET_PARAMS}{+END}&page={$PAGE&}}

{$,Infinite scrolling hides the pagination when it comes into view, and auto-loads the next link, appending below the current results}
{+START,IF,{$AND,{ALLOW_INFINITE_SCROLL},{$NEQ,{$_GET,keep_infinite_scroll},0}}}
{+START,IF,{$CONFIG_OPTION,infinite_scrolling}}
	{$SET,infinite_scroll_call_url,{$FACILITATE_AJAX_BLOCK_CALL,{BLOCK_PARAMS}}{+START,IF_PASSED,EXTRA_GET_PARAMS}{EXTRA_GET_PARAMS}{+END}}
{+END}
{+END}

<div class="tpl_placeholder" style="display: none;" data-tpl="ajaxPagination" data-tpl-params="{+START,PARAMS_JSON,wrapper_id,block_call_url,infinite_scroll_call_url}{_*}{+END}"></div>