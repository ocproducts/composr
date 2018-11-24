<label class="accessibility-hidden" for="{NAME*}">{LABEL*}</label>
<input type="text" size="20" name="{NAME*}" id="{NAME*}" class="form-control" value="{VALUE*}" />

{+START,IF_PASSED,HIDDEN_NAME}{+START,IF_PASSED,HIDDEN_VALUE}
	<input type="hidden" name="{HIDDEN_NAME*}" value="{HIDDEN_VALUE*}" />
{+END}{+END}
