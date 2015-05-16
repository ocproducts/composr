{+START,IF_EMPTY,{FIELDS}}
	<p class="nothing_here">
		{!NO_ENTRIES}
	</p>
{+END}
{+START,IF_NON_EMPTY,{FIELDS}}
	{MESSAGE}
	<div class="wide_table_wrap"><table class="columned_table results_table wide_table">
		{+START,IF,{$NOT,{$MOBILE}}}
			<colgroup>
				{+START,LOOP,WIDTHS}
					<col style="width: {_loop_var}{+START,IF,{$NOT,{$IN_STR,{_loop_var},px,%}}}px{+END}" />
				{+END}
			</colgroup>
		{+END}

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

