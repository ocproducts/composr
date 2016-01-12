{+START,IF_EMPTY,{GIFTS}}
	<p class="nothing_here">{!NONE}</p>
{+END}

{+START,IF_NON_EMPTY,{GIFTS}}
	<div class="wide_table_wrap">
		<table class="columned_table results_table wide_table autosized_table">
			<thead>
				<tr>
					<th>To</th>
					<th>&times;</th>
					<th>For</th>
				</tr>
			</thead>

			<tbody>
				{+START,LOOP,GIFTS}
					<tr>
						<td>{TO_LINK}</td>

						<td>{AMOUNT*}</td>

						<td>
							{+START,SET,gift_reason}
								{REASON*}

								{+START,IF,{$NOT,{ANONYMOUS}}}
									({FROM_NAME*})
								{+END}
								{+START,IF,{ANONYMOUS}}
									(Anonymous)
								{+END}
							{+END}
							{$TRUNCATE_LEFT,{$GET,gift_reason},20,1,1}
						</td>
					</tr>
				{+END}
			</tbody>
		</table>
	</div>
{+END}
