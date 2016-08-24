{$REQUIRE_JAVASCRIPT,editing}

<div id="container_for_{NAME*}" class="constrain_field" data-tbl-core-form-interfaces="formScreenInputText" data-tpl-args="{+START,PARAMS_JSON,REQUIRED,NAME}{_*}{+END}">
	<textarea{+START,IF,{$NOT,{$MOBILE}}} onchange="manage_scroll_height(this);" onkeyup="manage_scroll_height(this);"{+END} tabindex="{TABINDEX*}" class="input_text{REQUIRED*}{+START,IF,{SCROLLS}} textarea_scroll{+END} wide_field" cols="70" rows="{+START,IF_PASSED,ROWS}{ROWS*}{+END}{+START,IF_NON_PASSED,ROWS}7{+END}" id="{NAME*}" name="{NAME*}"{+START,IF_PASSED,MAXLENGTH} maxlength="{MAXLENGTH*}"{+END}>{DEFAULT*}</textarea>
	{+START,IF_PASSED,DEFAULT_PARSED}
	<textarea aria-hidden="true" cols="1" rows="1" style="display: none" readonly="readonly" disabled="disabled" name="{NAME*}_parsed">{DEFAULT_PARSED*}</textarea>
	{+END}

	{+START,IF_PASSED_AND_TRUE,RAW}<input type="hidden" name="pre_f_{NAME*}" value="1" />{+END}
</div>
