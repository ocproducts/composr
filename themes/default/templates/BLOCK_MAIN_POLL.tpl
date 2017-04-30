{$REQUIRE_JAVASCRIPT,checking}
{$SET,block_call_url,{$FACILITATE_AJAX_BLOCK_CALL,{BLOCK_PARAMS}}}
{$SET,wrapper_id,ajax_block_wrapper_{$RAND%}}
<div id="{$GET*,wrapper_id}" class="box_wrapper" data-tpl="blockMainPoll" data-tpl-params="{+START,PARAMS_JSON,wrapper_id,block_call_url}{_*}{+END}">
	{CONTENT}
</div>