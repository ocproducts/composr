<section class="box box___block_side_news_categories"><div class="box_inner">
	<h3>{!JUST_NEWS_CATEGORIES}</h3>

	<ul class="compact_list">
		{+START,LOOP,CATEGORIES}
			<li><a title="{NAME*}: {$STRIP_TAGS,{!CATEGORY_SUBORDINATE_2,{COUNT*}}}" href="{URL*}">{NAME*}</a></li>
		{+END}
	</ul>
</div></section>
