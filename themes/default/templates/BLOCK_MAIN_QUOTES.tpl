<section class="box box___block_main_quotes"><div class="box-inner">
	{+START,IF_NON_EMPTY,{TITLE}}<h3>{TITLE*}</h3>{+END}

	<blockquote class="quotes-block">
		{CONTENT}
	</blockquote>

	{+START,IF_NON_EMPTY,{EDIT_URL}}
		<ul class="horizontal-links associated-links-block-group">
			<li><a href="{EDIT_URL*}" title="{!EDIT}: {TITLE*}">{!EDIT}</a></li>
		</ul>
	{+END}
</div></section>
