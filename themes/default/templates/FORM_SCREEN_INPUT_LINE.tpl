<div class="constrain_field">
	<input size="{$?,{$MOBILE},30,40}"{+START,IF_PASSED,MAXLENGTH} maxlength="{MAXLENGTH*}"{+END}{+START,IF_NON_PASSED,MAXLENGTH} maxlength="255"{+END} tabindex="{TABINDEX*}" class="input_line{REQUIRED*}" type="{+START,IF_NON_PASSED,TYPE}text{+END}{+START,IF_PASSED,TYPE}{TYPE*}{+END}" id="{NAME*}" name="{NAME*}" value="{DEFAULT*}"{+START,IF_PASSED,PLACEHOLDER} placeholder="{PLACEHOLDER*}"{+END}{+START,IF_PASSED,PATTERN} pattern="{PATTERN*}"{+END} />
</div>

<script>// <![CDATA[
	{+START,INCLUDE,AUTOCOMPLETE_LOAD,.js,javascript}{+END}
//]]></script>
