<section class="box box___block_side_forum_news"><div class="box_inner">
	{+START,IF_NON_EMPTY,{TITLE}}<h3>{TITLE}</h3>{+END}

	{+START,IF_EMPTY,{CONTENT}}
		<p class="nothing_here">{!NO_NEWS}</p>
	{+END}
	{+START,IF_NON_EMPTY,{CONTENT}}
		<div class="webstandards_checker_off">
			{CONTENT}
		</div>
	{+END}

	{+START,IF_NON_EMPTY,{ARCHIVE_URL}{SUBMIT_URL}}
		<ul class="horizontal_links associated_links_block_group force_margin">
			{+START,IF_NON_EMPTY,{ARCHIVE_URL}}
				<li><a rel="archives" href="{ARCHIVE_URL*}">{!VIEW_ARCHIVE}</a></li>
			{+END}
			{+START,IF_NON_EMPTY,{SUBMIT_URL}}
				<li><a rel="add" href="{SUBMIT_URL*}">{!ADD_NEWS}</a></li>
			{+END}
		</ul>
	{+END}
</div></section>

