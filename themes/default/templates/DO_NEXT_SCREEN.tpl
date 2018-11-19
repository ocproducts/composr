<div data-tpl="doNextScreen">
	{+START,IF,{$EQ,{$PAGE},admin,cms}}
		{+START,IF,{$DESKTOP}}
			<div class="block-desktop">
				{TITLE}
			</div>
		{+END}
	{+END}
	{+START,IF,{$NEQ,{$PAGE},admin,cms}}
		{TITLE}
	{+END}

	{+START,IF_PASSED,TEXT}
		{$PARAGRAPH,{TEXT}}
	{+END}

	{INTRO}

	<p class="do-next-page-question">
		{QUESTION*}
	</p>

	{SECTIONS}
</div>
