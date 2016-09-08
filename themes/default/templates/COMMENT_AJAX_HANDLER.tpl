{$SET,url_stem,{$FIND_SCRIPT,post_comment}?options={OPTIONS}&hash={HASH}}
{$SET,infinite_scroll,{$AND,{$NOT,{IS_THREADED}},{$CONFIG_OPTION,infinite_scrolling}}}
<script type="application/json" data-tpl-core-feedback-features="commentAjaxHandler">
	{+START,PARAMS_JSON,OPTIONS,HASH,url_stem,infinite_scroll}{_/}{+END}
</script>
