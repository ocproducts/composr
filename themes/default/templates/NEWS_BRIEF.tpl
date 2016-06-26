<div class="box box___news_brief"><div class="box_inner">
	<span class="right float_separation">{DATE*}</span>

	<span><a href="{FULL_URL*}">{NEWS_TITLE}</a></span>
	{+START,IF_PASSED_AND_TRUE,COMMENT_COUNT} <span class="comment_count">{$COMMENT_COUNT,news,{ID}}</span>{+END}
</div></div>
