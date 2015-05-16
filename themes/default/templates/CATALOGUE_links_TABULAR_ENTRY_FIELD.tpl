<td>
	{+START,IF,{$EQ,{FIELDID},0}}
		<a target="_blank" title="{$STRIP_TAGS,{VALUE}} {!LINK_NEW_WINDOW}" href="{$GET*,FIELD_1_PLAIN}">{VALUE}</a>
	{+END}

	{+START,IF,{$NEQ,{FIELDID},0}}
		{VALUE}
	{+END}

	{+START,IF,{$NEQ,{FIELDID},0}}
		{+START,IF_NON_EMPTY,{$GET,EDIT_URL}}
			<p class="associated_details">
				( <a href="{$GET*,EDIT_URL}">{!EDIT}</a> )
			</p>
		{+END}
	{+END}
</td>

