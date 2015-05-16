<section class="box box___block_side_cns_private_topics"><div class="box_inner">
	<h3>{!UNSEEN_PERSONAL_POSTS}</h3>

	{+START,IF_NON_EMPTY,{CONTENT}}
		{CONTENT}
	{+END}
	{+START,IF_EMPTY,{CONTENT}}
		<p class="nothing_here">{!NO_INBOX}</p>
	{+END}

	{+START,IF_NON_EMPTY,{SEND_URL}{VIEW_URL}}
		<ul class="horizontal_links associated_links_block_group force_margin">
			{+START,IF_NON_EMPTY,{SEND_URL}}
				<li><a rel="archives" href="{SEND_URL*}">{!NEW_PRIVATE_TOPIC_SHORT}</a></li>
			{+END}
			{+START,IF_NON_EMPTY,{VIEW_URL}}
				<li><a rel="add" href="{VIEW_URL*}">{!VIEW_ARCHIVE}</a></li>
			{+END}
		</ul>
	{+END}
</div></section>

