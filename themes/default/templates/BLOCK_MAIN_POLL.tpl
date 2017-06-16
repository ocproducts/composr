{$REQUIRE_JAVASCRIPT,checking}
{$SET,block_call_url,{$FACILITATE_AJAX_BLOCK_CALL,{BLOCK_PARAMS}}}
{$SET,ajax_block_main_poll_wrapper,ajax_block_main_poll_wrapper_{$RAND%}}
<div id="{$GET*,ajax_block_main_poll_wrapper}" class="box_wrapper" data-tpl="blockMainPoll" data-tpl-params="{+START,PARAMS_JSON,ajax_block_main_poll_wrapper,block_call_url}{_*}{+END}">
	{CONTENT}
</div>
