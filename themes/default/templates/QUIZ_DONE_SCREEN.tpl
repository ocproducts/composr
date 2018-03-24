{TITLE}

<p class="quiz_result_headline">
	{RESULT}
</p>

{+START,IF_NON_EMPTY,{MESSAGE}}
	{$PARAGRAPH,{MESSAGE}}
{+END}

{+START,IF,{REVEAL_ANSWERS}}
	{$,Show a detailed table of how you did}
	{+START,INCLUDE,QUIZ_RESULTS}{+END}
{+END}

{+START,IF,{$NOT,{REVEAL_ANSWERS}}}
	{+START,IF_NON_EMPTY,{CORRECTIONS}{AFFIRMATIONS}}
		{$,Show a briefer list of explanations of why you're right or wrong [only if explanations were defined]}
		<p class="lonely_label">{!EXPLANATION}:</p>
		<ul class="spaced_list">
			{CORRECTIONS}{AFFIRMATIONS}
		</ul>
	{+END}
{+END}
