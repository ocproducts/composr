{$,Read the catalogue tutorial for information on custom catalogue layouts}

{$SET,EDIT_URL,{EDIT_URL}}

<tr class="{$CYCLE,results_table_zebra,zebra-0,zebra-1}">
	{FIELDS_TABULAR}
	{+START,IF_NON_EMPTY,{VIEW_URL}}
		<td>
			<!--VIEWLINK-->
			<a class="button-screen-item buttons--more" href="{VIEW_URL*}"><span>{+START,INCLUDE,ICON}NAME=buttons/more{+END} {!VIEW}</span></a>
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
