<section class="box box---block-side-news"><div class="box-inner">
	{+START,IF_NON_EMPTY,{TITLE}}<h3>{TITLE}</h3>{+END}

	{+START,IF_EMPTY,{CONTENT}}
		<p class="nothing-here">{$?,{BLOG},{!BLOG_NO_NEWS},{!NO_NEWS}}</p>
	{+END}
	{+START,IF_NON_EMPTY,{CONTENT}}
		{CONTENT}
	{+END}

	{+START,IF_NON_EMPTY,{ARCHIVE_URL}{SUBMIT_URL}}
		<ul class="horizontal-links associated-links-block-group force-margin">
			{+START,IF_NON_EMPTY,{ARCHIVE_URL}}
				<li><a rel="archives" href="{ARCHIVE_URL*}">{!VIEW_ARCHIVE}</a></li>
			{+END}
			{+START,IF_NON_EMPTY,{SUBMIT_URL}}
				<li><a rel="add" href="{SUBMIT_URL*}">{$?,{BLOG},{!ADD_NEWS_BLOG},{!ADD_NEWS}}</a></li>
			{+END}
		</ul>
	{+END}
</div></section>
