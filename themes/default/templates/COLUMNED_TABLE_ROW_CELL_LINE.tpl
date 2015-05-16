<label class="accessibility_hidden" for="{NAME*}">{LABEL*}</label>
<input type="text" size="20" name="{NAME*}" id="{NAME*}" value="{VALUE*}" />

{+START,IF_PASSED,HIDDEN_NAME}{+START,IF_PASSED,HIDDEN_VALUE}
	<input type="hidden" name="{HIDDEN_NAME*}" value="{HIDDEN_VALUE*}" />
{+END}{+END}
