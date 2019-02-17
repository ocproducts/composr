{+START,IF,{USING_TEXTAREA}}
	{$INIT,with_whitespace_id,0}
	{$INC,with_whitespace_id}

	<div class="constrain_field">
		<label class="accessibility_hidden" for="_with_whitespace_{$GET*,with_whitespace_id}">{!NA_EM}</label>
		<textarea onclick="this.select();" id="_with_whitespace_{$GET*,with_whitespace_id}" name="_with_whitespace_{$GET*,with_whitespace_id}" readonly="readonly" cols="70" rows="1" class="wide_field">{CONTENT*}</textarea>
	</div>

	<script>// <![CDATA[
		manage_scroll_height(document.getElementById('_with_whitespace_{$GET;/,with_whitespace_id}'));
	//]]></script>
{+END}
{+START,IF,{$NOT,{USING_TEXTAREA}}}
	<p class="whitespace_visible">{CONTENT*}</p>
{+END}
