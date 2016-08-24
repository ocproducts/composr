{$SET,wrapper_id,ajax_block_wrapper_{$RAND%}}
<div id="{$GET*,wrapper_id}" class="box_wrapper">
	{CONTENT}

	{$REQUIRE_JAVASCRIPT,ajax}
	{$REQUIRE_JAVASCRIPT,checking}

	{$SET,block_call_url,{$FACILITATE_AJAX_BLOCK_CALL,{BLOCK_PARAMS}}}
	<script type="application/json" data-tpl-polls="blockMainPoll">{+START,PARAMS_JSON,wrapper_id,block_call_url}{_/}{+END}</script>
</div>
