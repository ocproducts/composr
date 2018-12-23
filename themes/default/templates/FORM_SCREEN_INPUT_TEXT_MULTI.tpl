{$REQUIRE_JAVASCRIPT,core_form_interfaces}

<div data-tpl="formScreenInputTextMulti" class="multi-field form-screen-input-text-multi">
	<div class="accessibility-hidden"><label for="{NAME_STUB*}{I*}">{PRETTY_NAME*}</label></div>
	<textarea tabindex="{TABINDEX*}" rows="4" cols="10" class="input-text{REQUIRED*} form-control form-control-wide js-keypress-textarea-ensure-next-field" id="{NAME_STUB*}{I*}" name="{NAME_STUB*}{I*}"{+START,IF_PASSED,MAXLENGTH} maxlength="{MAXLENGTH*}"{+END}>{DEFAULT*}</textarea>
	<input type="hidden" name="label_for__{NAME_STUB*}{I*}" value="{PRETTY_NAME*}" />
</div>
