{$REQUIRE_JAVASCRIPT,checking}
{$REQUIRE_JAVASCRIPT,core_abstract_interfaces}

{$SET,ajax_internalised_ajax_wrapper,ajax_internalised_ajax_wrapper_{$RAND%}}

<div id="{$GET*,ajax_internalised_ajax_wrapper}" data-require-javascript="core_abstract_interfaces" data-tpl="internalizedAjaxScreen" data-tpl-params="{+START,PARAMS_JSON,CHANGE_DETECTION_URL,REFRESH_TIME,REFRESH_IF_CHANGED,URL}{_*}{+END}">
	{SCREEN_CONTENT}
</div>
