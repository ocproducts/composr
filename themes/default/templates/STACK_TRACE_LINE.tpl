<tr>
	<th>
		{KEY*}
	</th>

	<td>
		{+START,IF,{$AND,{$VALUE_OPTION,textmate},{$EQ,{KEY},Line}}}<a title="TextMate link" target="_self" href="txmt://open?url=file://{FILE*}&amp;line={LINE*}">{+END}{VALUE}{+START,IF,{$AND,{$VALUE_OPTION,textmate},{$EQ,{KEY},Line}}}</a>{+END}
	</td>
</tr>
