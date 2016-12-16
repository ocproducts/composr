{+START,IF,{$EQ,{$PAGE},admin,cms}}
	{+START,IF,{$NOT,{$MOBILE}}}
		<div class="block_desktop">
			{TITLE}
		</div>
	{+END}
{+END}
{+START,IF,{$NEQ,{$PAGE},admin,cms}}
	{TITLE}
{+END}

{+START,IF_PASSED,TEXT}
	<p>{TEXT}</p>
{+END}

{INTRO}

<p class="do_next_page_question">
	{QUESTION*}
</p>

{SECTIONS}
