{$,Read the catalogue tutorial for information on custom catalogue layouts}

<td>
	{VALUE}

	{+START,IF,{$NEQ,{FIELDID},0}}
		{+START,IF_NON_EMPTY,{$GET,EDIT_URL}}
			<p class="associated_details">
				( <a href="{$GET*,EDIT_URL}">{!EDIT}</a> )
			</p>
		{+END}
	{+END}
</td>

