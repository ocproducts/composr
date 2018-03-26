<label class="accessibility-hidden" for="{NAME*}">{LABEL*}</label>
<input type="checkbox" name="{NAME*}" id="{NAME*}" value="{VALUE*}"{+START,IF_PASSED_AND_TRUE,TICKED} checked="checked"{+END} />
{+START,IF_PASSED,HIDDEN}{HIDDEN}{+END}
