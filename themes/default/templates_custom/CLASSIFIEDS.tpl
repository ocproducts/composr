<p class="accessibility_hidden">
	{!CLASSIFIEDS_PRICING}
</p>

<div class="wide_table_wrap"><table class="columned_table wide_table results_table autosized_table spaced_table">
	<thead>
		<tr>
			<th>
				{!CLASSIFIED_DISPLAY_PERIOD}
			</th>
			<th>
				{!PRICE}
			</th>
		</tr>
	</thead>

	<tbody>
		{+START,LOOP,DATA}
			<tr>
				<td>
					{LABEL*}
				</td>
				<td>
					{+START,IF,{$EQ,{PRICE},0}}
						<em>{!CLASSIFIED_FREE}</em>
					{+END}
					{+START,IF,{$NEQ,{PRICE},0}}
						{$CURRENCY,{PRICE},{CURRENCY},{$?,{$CONFIG_OPTION,currency_auto},{$CURRENCY_USER},{$CURRENCY}}}
					{+END}
				</td>
			</tr>
		{+END}
	</tbody>
</table></div>
