<section class="box box___block_side_forum_news"><div class="box-inner">
	{+START,IF_NON_EMPTY,{TITLE}}<h3>{TITLE}</h3>{+END}

	{+START,IF_EMPTY,{NEWS}}
		<p class="nothing-here">{!NO_NEWS}</p>
	{+END}
	{+START,IF_NON_EMPTY,{NEWS}}
		<div class="webstandards-checker-off">
			{+START,LOOP,NEWS}
				<div class="box box___block_side_forum_news_summary"><div class="box-inner">
					<p class="tiny-paragraph">
						<a title="{$STRIP_TAGS,{NEWS_TITLE}}" href="{FULL_URL*}">{$TRUNCATE_LEFT,{NEWS_TITLE},30,0,1}</a>
					</p>

					<div role="note">
						<ul class="compact-list tiny-paragraph associated-details">
							<li>{!BY_SIMPLE,{$DISPLAYED_USERNAME*,{FIRSTUSERNAME}}}</li>
							<li>{!_COMMENTS,{$SUBTRACT,{REPLIES},1}}</li>
							<li><span class="must-show-together">{!LAST_POST}:</span> <span class="must-show-together">{DATE*}</span></li>
						</ul>
					</div>
				</div></div>
			{+END}
		</div>
	{+END}

	{+START,IF_NON_EMPTY,{ARCHIVE_URL}{SUBMIT_URL}}
		<ul class="horizontal-links associated-links-block-group force-margin">
			{+START,IF_NON_EMPTY,{ARCHIVE_URL}}
				<li><a rel="archives" href="{ARCHIVE_URL*}">{!VIEW_ARCHIVE}</a></li>
			{+END}
			{+START,IF_NON_EMPTY,{SUBMIT_URL}}
				<li><a rel="add" href="{SUBMIT_URL*}">{!ADD_NEWS}</a></li>
			{+END}
		</ul>
	{+END}
</div></section>
