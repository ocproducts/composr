{+START,IF_PASSED,TEXT_ID}{$SET,TEXT_ID,{TEXT_ID}}{+END}

{+START,IF_EMPTY,{FIELDS}}
	<p class="nothing_here">
		{!NO_ENTRIES}
	</p>
{+END}

{+START,IF_NON_EMPTY,{FIELDS}}
	{$PARAGRAPH,{MESSAGE}}

	<div class="wide-table-wrap"><table class="columned_table results-table wide-table{+START,IF_EMPTY,{WIDTHS}} autosized_table{+END} responsive-table" itemprop="significantLinks">
		{+START,IF,{$DESKTOP}}{+START,IF,{$EQ,{$LANG},EN}}{+START,IF_NON_EMPTY,{WIDTHS}}
			<colgroup>
				{+START,LOOP,WIDTHS}
					<col style="width: {_loop_var}{+START,IF,{$NOT,{$IN_STR,{_loop_var},px,%}}}px{+END}" />
				{+END}
			</colgroup>
		{+END}{+END}{+END}

		<thead>
			<tr>
				{FIELDS_TITLE}
			</tr>
		</thead>
		<tbody>
			{FIELDS}
		</tbody>
	</table></div>

	{+START,SET,RESULTS_TABLE_PAGINATION}
		{+START,IF_NON_EMPTY,{SORT}{PAGINATION}}
			<div class="box results-table-under"><div class="box-inner float-surrounder">
				{+START,IF_NON_EMPTY,{SORT}}
					<div class="results-table-sorter">
						{SORT}
					</div>
				{+END}

				{PAGINATION}
			</div></div>
		{+END}
	{+END}
	{+START,IF,{$NOT,{$GET,DEFER_RESULTS_TABLE_PAGINATION}}}
		{$GET,RESULTS_TABLE_PAGINATION}
	{+END}
{+END}
