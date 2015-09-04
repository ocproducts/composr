<div class="box box___news_brief"><div class="box_inner">
	<span class="right float_separation">{DATE*}</span>

	<span><a href="{FULL_URL*}">{+START,FRACTIONAL_EDITABLE,{NEWS_TITLE_PLAIN},title,_SEARCH:cms_news:__edit:{ID},1}{NEWS_TITLE}{+END}</a></span>
	{+START,IF_PASSED_AND_TRUE,COMMENT_COUNT} <span class="comment_count">{$COMMENT_COUNT,news,{ID}}</span>{+END}
</div></div>
