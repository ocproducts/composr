<p>
	{!STACK_TRACE_INFORMATION,{$BRAND_NAME*}}
</p>

{+START,LOOP,TRACE}
	<div class="wide-table-wrap"><table class="map_table wide-table results-table">
		<colgroup>
			<col class="field-name-column" />
			<col class="field_value_column" />
		</colgroup>

		<tbody>
			{+START,LOOP,TRACES}
				<tr>
					<th>
						{KEY*}
					</th>

					<td>
						{+START,IF,{$AND,{$VALUE_OPTION,textmate},{$EQ,{KEY},Line}}}<a title="TextMate link" target="_self" href="txmt://open?url=file://{FILE*}&amp;line={LINE*}">{+END}{VALUE}{+START,IF,{$AND,{$VALUE_OPTION,textmate},{$EQ,{KEY},Line}}}</a>{+END}
					</td>
				</tr>
			{+END}
		</tbody>
	</table></div>
{+END}

{+START,IF_NON_EMPTY,{POST}}
	<h2>{!PARAMETERS}</h2>

	<div class="wide-table-wrap"><table class="map_table wide-table results-table">
		<colgroup>
			<col class="field-name-column" />
			<col class="field_value_column" />
		</colgroup>

		<tbody>
			{+START,LOOP,POST}
				<tr>
					<th>
						{_loop_key*}
					</th>
					<td>
						<div class="whitespace_visible">{+START,IF_PASSED,_loop_var}{_loop_var*}{+END}{+START,IF_NON_PASSED,_loop_var}?{+END}</div>
					</td>
				</tr>
			{+END}
		</tbody>
	</table></div>
{+END}
