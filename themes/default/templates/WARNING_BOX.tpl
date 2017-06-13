{+START,SET,warning_box}
	<p class="red_alert{+START,IF_PASSED_AND_TRUE,INLINE} inline{+END}" role="error">
		{WARNING}
	</p>
	{+START,IF_PASSED_AND_TRUE,INLINE}&nbsp;{+END}
{+END}

{+START,IF_NON_PASSED,RESTRICT_VISIBILITY}
	{$GET,warning_box}
{+END}

{+START,IF_PASSED,RESTRICT_VISIBILITY}
	{+START,IF,{$OR,{$IS_STAFF},{$EQ,{RESTRICT_VISIBILITY},{$MEMBER}}}}
		{$GET,warning_box}
	{+END}
{+END}
