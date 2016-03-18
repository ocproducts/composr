{+START,IF,{$EQ,{TITLE},{!GLOBAL_NAVIGATION}}}
<hr class="spaced_rule" />
{+END}

<nav class="do_next_section_wrap">
	{+START,IF_NON_EMPTY,{TITLE}}{+START,IF,{$NEQ,{TITLE},{$PAGE_TITLE},{!ENTRIES}}}
		<h2>{TITLE}</h2>
	{+END}{+END}

	<div class="do_next_section">
		{CONTENT}
	</div>
</nav>
