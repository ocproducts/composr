{$REQUIRE_JAVASCRIPT,ajax}
{$REQUIRE_JAVASCRIPT,checking}
{$REQUIRE_JAVASCRIPT,core_abstract_interfaces}
{$SET,wrapper_id,ajax_block_wrapper_{$RAND%}}
<div id="{$GET*,wrapper_id}" data-tpl="internalizedAjaxScreen"
	 data-tpl-params="{+START,PARAMS_JSON,CHANGE_DETECTION_URL,REFRESH_TIME,REFRESH_IF_CHANGED,URL}{_*}{+END}">
	{SCREEN_CONTENT}
</div>



