{+START,IF_PASSED,CONTENT}
	<div class="search_result">
		{+START,SET,commented_out}
			{+START,IF_PASSED,TYPE}
				{+START,IF_PASSED,ID}
					<input class="right" type="hidden" name="result__{TYPE*}_{ID*}" value="1" />
				{+END}
			{+END}
		{+END}

		{CONTENT}
	</div>
{+END}

{+START,IF_NON_PASSED,CONTENT}
	{+START,IF_PASSED,TYPE}
		{+START,IF_PASSED,ID}
			<input style="display: none" type="hidden" name="result__{TYPE*}_{ID*}" value="0" />
		{+END}
	{+END}
{+END}
