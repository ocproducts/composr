<section class="box box___block_main_quotes"><div class="box_inner">
	{+START,IF_NON_EMPTY,{TITLE}}<h3>{TITLE*}</h3>{+END}

	<blockquote class="quotes_block">
		{CONTENT}
	</blockquote>

	{+START,IF_NON_EMPTY,{EDIT_URL}}
		<ul class="horizontal_links associated_links_block_group">
			<li><a href="{EDIT_URL*}" title="{!EDIT}: {TITLE*}">{!EDIT}</a></li>
		</ul>
	{+END}
</div></section>

