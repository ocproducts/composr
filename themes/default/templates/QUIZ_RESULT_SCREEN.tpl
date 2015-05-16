{TITLE}

<p class="quiz_result_headline">
	{!QUIZ_WAS_ENTERED_AS_FOLLOWS,{USERNAME*},{MEMBER_URL*},{DATE*},{QUIZ_NAME*},{TYPE*}}
</p>

{+START,INCLUDE,QUIZ_RESULTS}{+END}

{+START,IF,{$NEQ,{_TYPE},SURVEY}}
	<p class="lonely_label">
		{!QUIZ_RESULTS}:
	</p>

	<dl class="compact_list">
		<dt>{!MARKS}</dt>
		<dd>{MARKS_RANGE*} / {OUT_OF*}</dd>

		<dt>{!PERCENTAGE}</dt>
		<dd>{PERCENTAGE_RANGE*}%</dd>

		{+START,IF,{$EQ,{_TYPE},TEST}}
			<dt>{!STATUS}</dt>
			<dd>
				{+START,IF_PASSED,PASSED}
					{+START,IF,{PASSED}}
						<span class="multilist_mark yes">{!PASSED}</span>
					{+END}

					{+START,IF,{$NOT,{PASSED}}}
						<span class="multilist_mark no">{!FAILED}</span>
					{+END}
				{+END}

				{+START,IF_NON_PASSED,PASSED}
					{!UNKNOWN}
				{+END}
			</dd>
		{+END}
	</dl>
{+END}
