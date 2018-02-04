<tr>
	<th class="de-th cns-topic-poll-radio cns-column1">{+START,FRACTIONAL_EDITABLE,{ANSWER},answer_{I},_SEARCH:cms_polls:_edit_poll:{ID}}{ANSWER*}{+END}</th>
	<td class="cns-topic-poll-radio-2 cns-column2"><div class="accessibility-hidden"><label for="vote_{I*}">{ANSWER*}</label></div><input {+START,IF,{$NOT,{REAL_BUTTON}}} disabled="disabled"{+END} type="radio" id="vote-{I*}" name="vote" value="{I*}" /></td>
</tr>
