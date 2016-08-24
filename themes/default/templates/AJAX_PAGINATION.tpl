{$REQUIRE_JAVASCRIPT,ajax}
{$REQUIRE_JAVASCRIPT,core_abstract_interfaces}
<script type="application/json" data-tpl-core-abstract-interfaces="ajaxPagination">
[
	{+START,PARAMS_JSON,ALLOW_INFINITE_SCROLL,wrapper_id}{_/}{+END},
	"{$FACILITATE_AJAX_BLOCK_CALL#,{BLOCK_PARAMS}}{+START,IF_PASSED,EXTRA_GET_PARAMS}{EXTRA_GET_PARAMS#/}{+END}"
	"&page={$PAGE&}",
	{$CONFIG_OPTION,infinite_scrolling}
]
</script>