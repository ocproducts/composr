{+START,IF,{$NEQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
	{$SET,ajax_block_main_news_wrapper,ajax-block-main-news-wrapper-{$RAND%}}
	<div id="{$GET*,ajax_block_main_news_wrapper}" class="box-wrapper">
		<section class="box box---block-main-news"><div class="box-inner compacted-subbox-stream{+START,IF,{$GET,large_news_posts}} less-compact{+END}">
			{+START,IF,{$NOT,{BLOG}}}{+START,IF_NON_EMPTY,{TITLE}}
				<h2>{TITLE}</h2>
			{+END}{+END}

			{+START,IF_EMPTY,{BRIEF}{CONTENT}}
				<p class="nothing-here">{!NO_ENTRIES,news}</p>
			{+END}

			<div class="raw-ajax-grow-spot">
				{CONTENT}

				{+START,IF_NON_EMPTY,{BRIEF}}
					{+START,IF_NON_EMPTY,{CONTENT}}
						<h3>{$?,{BLOG},{!BLOG_OLDER_NEWS},{!OLDER_NEWS}}</h3>
					{+END}

					{BRIEF}
				{+END}
			</div>

			{+START,IF_PASSED,PAGINATION}
				{+START,IF_NON_EMPTY,{PAGINATION}}
					<div class="pagination-spacing float-surrounder ajax-block-wrapper-links">
						{PAGINATION}
					</div>
				{+END}
			{+END}

			{+START,IF_NON_EMPTY,{ARCHIVE_URL}{SUBMIT_URL}{RSS_URL}{ATOM_URL}}
				<ul class="horizontal-links associated-links-block-group">
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
				{+START,INCLUDE,AJAX_PAGINATION}
					WRAPPER_ID={$GET,ajax_block_main_news_wrapper}
					ALLOW_INFINITE_SCROLL=1
				{+END}
			{+END}
		{+END}
	</div>
{+END}

{+START,IF,{$EQ,{$COMMA_LIST_GET,{BLOCK_PARAMS},raw},1}}
	{CONTENT}
	{BRIEF}

	{PAGINATION}
{+END}
