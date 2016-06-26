{$,Read the catalogue tutorial for information on custom catalogue layouts}

{$SET,EDIT_URL,{EDIT_URL}}

<tr class="{$CYCLE,results_table_zebra,zebra_0,zebra_1}">
	{FIELDS_TABULAR}
	{+START,IF_NON_EMPTY,{VIEW_URL}}
		<td>
			<!--VIEWLINK-->
			<a class="button_screen_item buttons__more" href="{VIEW_URL*}"><span>{!VIEW}</span></a>
		</td>
	{+END}
	{$, Uncomment to show ratings
	<td>
		{+START,IF_NON_EMPTY,{$TRIM,{RATING}}}
			{RATING}
		{+END}
		{+START,IF_EMPTY,{$TRIM,{RATING}}}
			{!UNRATED}
		{+END}
	</td>
	}
</tr>

