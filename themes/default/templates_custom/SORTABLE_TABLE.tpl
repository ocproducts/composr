{$REQUIRE_JAVASCRIPT,sortable_tables}

<div data-require-javascript="sortable_tables" data-tpl="sortableTable" class="wide-table-wrap">
	<table id="sortable_table_{ID*}" class="results-table wide-table columned_table autosized-table sortable_table table-autosort:{DEFAULT_SORT_COLUMN*} table-autofilter table-autopage:{MAX*}">
		<thead>
			<tr>
				{+START,LOOP,HEADERS}
					<th class="table-sortable:{SORTABLE_TYPE*}{+START,IF_NON_EMPTY,{FILTERABLE}} table-filterable{+END}{+START,IF,{SEARCHABLE}} table-searchable table-searchable-with-substrings{+END}">
						<span>{LABEL*}</span>
						{$,	If you want the template to define sorting, uncomment this and remove table-filterable -- but it will not be sorted consistently
							{+START,IF_NON_EMPTY,{FILTERABLE}}
								<select class="js-change-sortable-table-filter">
									<option value="">All</option>
									{+START,LOOP,FILTERABLE}
										<option>{_loop_var*}</option>
									{+END}
								</select>
							{+END}
						}
					</th>
				{+END}
			</tr>
		</thead>

		<tbody>
			{ROWS}

			{$,Fudge so that last-child bottom curved border continues to work}
			<tr class="table-nofilter table-nosort trailing-row">
				{+START,LOOP,HEADERS}
					<td></td>
				{+END}
			</tr>
		</tbody>
	</table>

	{+START,IF,{$GT,{NUM_ROWS},{MAX}}}
		<div class="pagination force_margin">
			<nav class="float-surrounder">
				<!--<a href="#!" class="table-page:1 results_continue">{!FIRST}</a>--><a href="#!" class="table-page:previous results_continue">&laquo; {!PREVIOUS}</a><a href="#!" class="table-page:next results_continue">{!NEXT} &raquo;</a><span class="table-page-number results_page_num">1</span><span>of</span><span class="table-page-count results_page_num">1</span>
			</nav>
		</div>
	{+END}
</div>
