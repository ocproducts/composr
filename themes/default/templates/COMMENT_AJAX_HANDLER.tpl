{$SET,url_stem,{$FIND_SCRIPT,post_comment}?options={OPTIONS}&hash={HASH}}
{$SET,infinite_scroll,0}
{+START,IF,{$NOT,{IS_THREADED}}}{+START,IF,{$CONFIG_OPTION,infinite_scrolling}}
	{$SET,infinite_scroll,1}
{+END}{+END}
<script type="application/json" data-tpl-core-feedback-features="commentAjaxHandler">
	{+START,PARAMS_JSON,OPTIONS,HASH,url_stem,infinite_scroll}{_/}{+END}
</script>
