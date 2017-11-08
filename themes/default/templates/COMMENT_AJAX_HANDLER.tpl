{$REQUIRE_JAVASCRIPT,core_feedback_features}
{$SET,url_stem,{$FIND_SCRIPT,post_comment}?options={OPTIONS}&hash={HASH}}
{$SET,infinite_scroll,{$AND,{$NOT,{IS_THREADED}},{$THEME_OPTION,infinite_scrolling}}}
<div class="tpl_placeholder" style="display: none;" data-tpl="commentAjaxHandler" data-tpl-params="{+START,PARAMS_JSON,OPTIONS,HASH,url_stem,infinite_scroll}{_*}{+END}"></div>
