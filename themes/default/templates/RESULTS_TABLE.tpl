{+START,IF_PASSED,TEXT_ID}{$SET,TEXT_ID,{TEXT_ID}}{+END}

{+START,IF_EMPTY,{FIELDS}}
	<p class="nothing_here">
		{!NO_ENTRIES}
	</p>
{+END}

{+START,IF_NON_EMPTY,{FIELDS}}
	{$PARAGRAPH,{MESSAGE}}

	<div class="wide_table_wrap"><table class="columned_table results_table wide_table{+START,IF_EMPTY,{WIDTHS}} autosized_table{+END}" itemprop="significantLinks">
		{+START,IF,{$NOT,{$MOBILE}}}{+START,IF,{$EQ,{$LANG},EN}}{+START,IF_NON_EMPTY,{WIDTHS}}
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
			<div class="box results_table_under"><div class="box_inner float_surrounder">
				{+START,IF_NON_EMPTY,{SORT}}
					<div class="results_table_sorter">
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

