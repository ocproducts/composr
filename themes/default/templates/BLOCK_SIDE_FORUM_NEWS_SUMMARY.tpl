<div class="box box___block_side_forum_news_summary"><div class="box_inner">
	<p class="tiny_paragraph">
		<a title="{$STRIP_TAGS,{NEWS_TITLE}} {!LINK_NEW_WINDOW}" rel="external" target="_blank" href="{FULL_URL*}">{$TRUNCATE_LEFT,{NEWS_TITLE},30,0,1}</a>
	</p>

	<ul class="horizontal_meta_details tiny_paragraph associated_details" role="note">
		<li>{!BY_SIMPLE,{$DISPLAYED_USERNAME*,{FIRSTUSERNAME}}}</li>
		<li>{!_COMMENTS,{$SUBTRACT,{REPLIES},1}}</li>
	</ul>

	<p class="tiny_paragraph associated_details">
		<span class="field_name">{!LAST_POST}:</span> {DATE*}
	</p>
</div></div>
