{+START,IF,{$NEQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
	{$SET,wrapper_id,ajax_block_wrapper_{$RAND%}}
	<div id="{$GET*,wrapper_id}" class="box_wrapper">
		<section class="box box___block_main_news"><div class="box_inner compacted_subbox_stream{+START,IF,{$GET,large_news_posts}} less_compact{+END}">
			{+START,IF,{$NOT,{BLOG}}}{+START,IF_NON_EMPTY,{TITLE}}
				<h2>{TITLE}</h2>
			{+END}{+END}

			{+START,IF_EMPTY,{BRIEF}{CONTENT}}
				<p class="nothing_here">{!NO_ENTRIES,news}</p>
			{+END}

			<div class="raw_ajax_grow_spot">
				{CONTENT}

				{+START,IF_NON_EMPTY,{BRIEF}}
					<h3>{$?,{BLOG},{!BLOG_OLDER_NEWS},{!OLDER_NEWS}}</h3>

					{BRIEF}
				{+END}
			</div>

			{+START,IF_PASSED,PAGINATION}
				{+START,IF_NON_EMPTY,{PAGINATION}}
					<div class="pagination_spacing float_surrounder ajax_block_wrapper_links">
						{PAGINATION}
					</div>
				{+END}
			{+END}

			{+START,IF_NON_EMPTY,{ARCHIVE_URL}{SUBMIT_URL}{RSS_URL}{ATOM_URL}}
				<ul class="horizontal_links associated_links_block_group">
					{+START,IF_NON_EMPTY,{ARCHIVE_URL}}
						<li><a rel="archives" href="{ARCHIVE_URL*}">{!VIEW_ARCHIVE}</a></li>
					{+END}
					{+START,IF_NON_EMPTY,{SUBMIT_URL}}
						<li><a rel="add" href="{SUBMIT_URL*}">{$?,{BLOG},{!ADD_NEWS_BLOG},{!ADD_NEWS}}</a></li>
					{+END}
					{+START,IF_NON_EMPTY,{RSS_URL}}
						<li><a href="{RSS_URL*}"><abbr title="Really Simple Syndication">RSS</abbr></a></li>
					{+END}
					{+START,IF_NON_EMPTY,{ATOM_URL}}
						<li><a href="{ATOM_URL*}">Atom</a></li>
					{+END}
				</ul>
			{+END}
		</div></section>

		{+START,IF_PASSED,PAGINATION}
			{+START,IF_NON_EMPTY,{PAGINATION}}
				{+START,INCLUDE,AJAX_PAGINATION}ALLOW_INFINITE_SCROLL=1{+END}
			{+END}
		{+END}
	</div>
{+END}

{+START,IF,{$EQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
	{CONTENT}
	{BRIEF}

	{PAGINATION}
{+END}
