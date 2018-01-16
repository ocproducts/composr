<div class="wide-table-wrap"><table class="columned-table results-table wide-table autosized-table responsive-table">
	<colgroup>
		<col class="quiz_done_results_col_was_correct" />
		<col class="quiz_done_results_col_question" />
		<col class="quiz_done_results_col_given_answer" />
		<col class="quiz_done_results_col_correct_answer" />
	</colgroup>

	<thead>
		<tr>
			<th></th>
			<th>{!QUESTION}</th>
			<th>{!GIVEN_ANSWER}</th>
			<th>{!CORRECT_ANSWER}</th>
		</tr>
	</thead>
	<tbody>
		{+START,LOOP,GIVEN_ANSWERS_ARR}
			{$SET,cycle,{$CYCLE,results_table_zebra,zebra-0,zebra-1}}

			<tr class="{$GET,cycle} thick-border">
				<td class="quiz_answer_status">
					{+START,IF_PASSED,WAS_CORRECT}
						{+START,IF,{WAS_CORRECT}}
							<span class="multilist-mark yes">&#10004;</span>
						{+END}
						{+START,IF,{$NOT,{WAS_CORRECT}}}
							<span class="multilist-mark no">&#10005;</span>
						{+END}
					{+END}
					{+START,IF_NON_PASSED,WAS_CORRECT}
						&ndash;
					{+END}
				</td>

				<td class="quiz_result_question">
					{$COMCODE,{QUESTION}}
				</td>

				<td class="quiz_result_given_answer">
					{$COMCODE,{GIVEN_ANSWER},1}
				</td>

				<td class="quiz_result_answer">
					{+START,IF_NON_EMPTY,{CORRECT_ANSWER}}
						{$COMCODE,{CORRECT_ANSWER}}
					{+END}

					{+START,IF_EMPTY,{CORRECT_ANSWER}}
						<em>{!MANUALLY_MARKED}</em>
					{+END}
				</td>
			</tr>

			{+START,IF_PASSED,CORRECT_EXPLANATION}{+START,IF_NON_EMPTY,{CORRECT_EXPLANATION}}
				<tr class="{$GET,cycle}">
					<td class="responsive-table-no-prefix" colspan="4">
						<span class="field-name">{!EXPLANATION}:</span> {$COMCODE,{CORRECT_EXPLANATION}}
					</td>
				</tr>
			{+END}{+END}
		{+END}
	</tbody>
</table></div>
