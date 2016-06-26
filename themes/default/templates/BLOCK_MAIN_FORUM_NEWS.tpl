<section class="box box___block_main_forum_news"><div class="box_inner">
	{+START,IF_NON_EMPTY,{TITLE}}<h2>{TITLE}</h2>{+END}

	<div class="webstandards_checker_off">
		{CONTENT}
	</div>

	{+START,IF_NON_EMPTY,{ARCHIVE_URL}}
		<ul class="horizontal_links associated_links_block_group force_margin">
			<li><a href="{ARCHIVE_URL*}">{!VIEW_ARCHIVE}</a></li>
		</ul>
	{+END}
</div></section>

