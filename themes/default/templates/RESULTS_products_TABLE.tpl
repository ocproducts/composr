{+START,IF_EMPTY,{FIELDS}}
	<p class="nothing-here">
		{!NO_ENTRIES}
	</p>
{+END}
{+START,IF_NON_EMPTY,{FIELDS}}
	{MESSAGE}
	<div class="wide-table-wrap"><table class="columned-table results-table wide-table responsive-table">
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
{+END}
