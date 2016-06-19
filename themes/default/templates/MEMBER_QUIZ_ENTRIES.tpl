{+START,IF_NON_EMPTY,{CATEGORIES}}
	<div>
		<h2>
			<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode);"><img alt="{!EXPAND}: {!TEST_RESULTS}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand}" srcset="{$IMG*,2x/trays/expand} 2x" /></a>
			<span onclick="/*Access-note: code has other activation*/ return toggleable_tray(this.parentNode.parentNode);">{!TEST_RESULTS}</span>
		</h2>

		<div class="toggleable_tray" style="display: none" aria-expanded="false">
			{+START,LOOP,CATEGORIES}
				{$,If more than one category of quiz entered then show headers}
				{+START,IF,{$OR,{$GET,want_sections},{$NEQ,{CATEGORIES},1}}}
					<h3>{_loop_key*}</h3>
				{+END}

				{+START,IF_NON_EMPTY,{DELETE_URL}}
				<form action="{DELETE_URL*}" method="post" title="{!QUIZ}: {!DELETE}" autocomplete="off">
					{$INSERT_SPAMMER_BLACKHOLE}
				{+END}
				<div class="wide_table_wrap"><table class="columned_table wide_table results_table autosized_table">
					<thead>
						<tr>
							<th>
								{!NAME}
							</th>

							<th>
								{!DATE}
							</th>

							<th>
								{!MARKS}
							</th>

							<th>
								{!PERCENTAGE}
							</th>

							<th>
								{!STATUS}
							</th>

							{+START,IF_NON_EMPTY,{DELETE_URL}}
								<th>
									{!DELETE}
								</th>
							{+END}
						</tr>
					</thead>

					<tbody>
						{+START,LOOP,QUIZZES}
							<tr>
								<td>
									<a onmouseover="if (typeof window.activate_tooltip!='undefined') activate_tooltip(this,event,'{QUIZ_START_TEXT;^*}','auto');" href="{QUIZ_URL*}">{QUIZ_NAME*}</a>
								</td>

								<td>
									{+START,IF,{$HAS_ACTUAL_PAGE_ACCESS,admin_quiz,adminzone}}
										<a href="{$PAGE_LINK*,adminzone:admin_quiz:__quiz_results:{ENTRY_ID}}">{ENTRY_DATE*}</a>
									{+END}

									{+START,IF,{$NOT,{$HAS_ACTUAL_PAGE_ACCESS,admin_quiz,adminzone}}}
										{ENTRY_DATE*}
									{+END}
								</td>

								<td>
									{MARKS_RANGE*} / {OUT_OF*}
								</td>

								<td>
									{PERCENTAGE_RANGE*}%
								</td>

								<td>
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
								</td>

								{+START,IF_NON_EMPTY,{DELETE_URL}}
									<td>
										<label for="delete_quiz_{ENTRY_ID*}">{!DELETE}: {QUIZ_NAME*}</label>
										<input type="checkbox" id="delete_quiz_{ENTRY_ID*}" name="delete_{ENTRY_ID*}" value="1" />
									</td>
								{+END}
							</tr>
						{+END}
					</tbody>

					{+START,IF_NON_EMPTY,{DELETE_URL}}
						<tfoot>
							<tr>
								<td colspan="6">
								</td>

								<td>
									<input type="submit" value="{!DELETE}" />
								</td>
							</tr>
						</tfoot>
					{+END}
				</table></div>
				{+START,IF_NON_EMPTY,{DELETE_URL}}
				</form>
				{+END}

				{SORTING}

				{$,If more than one category of quiz entered then show summaries}
				{+START,IF,{$OR,{$GET,want_sections},{$NEQ,{CATEGORIES},1}}}
					<p class="lonely_label">
						{!RESULT_OVERVIEW}:
					</p>

					<dl class="compact_list">
						<dt>{!MARKS}</dt>
						<dd>{$FLOAT_FORMAT*,{RUNNING_MARKS},2,1}/{RUNNING_OUT_OF*}</dd>

						<dt>{!PERCENTAGE}</dt>
						<dd>{$FLOAT_FORMAT*,{RUNNING_PERCENTAGE},2,1}%</dd>
					</dl>
				{+END}
			{+END}
		</div>
	</div>
{+END}
