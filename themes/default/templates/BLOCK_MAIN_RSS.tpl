<section class="box box___block_main_rss"><div class="box_inner compacted_subbox_stream">
	<h3>{$?,{$IS_NON_EMPTY,{TITLE}},{!NEWS_FROM}: {TITLE`}}</h3>

	<div class="webstandards_checker_off">
		{+START,IF_NON_EMPTY,{AUTHOR}}
			<p>{AUTHOR`}</p>
		{+END}

		{CONTENT`}

		{+START,IF_NON_EMPTY,{COPYRIGHT}}
			<p>{COPYRIGHT`}</p>
		{+END}
	</div>
</div></section>

