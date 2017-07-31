{+START,IF_EMPTY,{CATEGORIES}}
	<p class="nothing_here">{!NO_HEALTH_ISSUES_FOUND}</p>
{+END}

{+START,IF_NON_EMPTY,{CATEGORIES}}
	<p><img class="activate_rich_semantic_tooltip help_icon vertical_alignment" alt="" src="{$IMG*,icons/16x16/help}" srcset="{$IMG*,icons/32x32/help} 2x" /> {!HELP_THRESHOLDS}</p>

	{+START,LOOP,CATEGORIES}
		<h2>{_loop_key*}</h2>

		<table class="wide_table results_table columned_table">
			<colgroup>
				<col />
				<col style="width: 8em" />
				<col style="width: 8em" />
			</colgroup>

			<thead>
				<tr>
					<th>
						{!SECTION}
					</th>
					<th colspan="2">
						{!RESULTS}
					</th>
				</tr>
			</thead>

			<tbody>
				{+START,LOOP,SECTIONS}
					<tr>
						<th>
							<em>{_loop_key*}</em>
						</th>
						<th>
							<em>{!PASSES}</em>
						</th>
						<th>
							<em>{!FAILS}</em>
						</th>
					</tr>

					<tr>
						<td>
							<p>
								{!MESSAGES} / {!REASONS}&hellip;
							</p>
							{+START,LOOP,RESULTS}
								<div>
									{+START,CASES,{RESULT}}
										FAIL=<strong>{!CHECK_FAILED}</strong>: <span style="color: red">{MESSAGE}</span>
										PASS=<strong>{!CHECK_PASSED}</strong>: <span style="color: green">{MESSAGE}</span>
										SKIP=<strong>{!CHECK_SKIPPED}</strong>: <span style="color: gray">{MESSAGE}</span>
										MANUAL=<strong>{!CHECK_MANUAL}</strong>: <span style="color: orange">{MESSAGE}</span>
									{+END}
								</div>
							{+END}
						</td>
						<td>
							{NUM_PASSES*}
						</td>
						<td>
							{NUM_FAILS*}
						</td>
					</tr>
				{+END}
			</tbody>
		</table>
	{+END}
{+END}
