<div class="constrain_field">
	<div class="accessibility_hidden"><label for="{NAME_STUB*}{I*}">{PRETTY_NAME*}</label></div>
	<textarea tabindex="{TABINDEX*}" rows="4" cols="10" class="input_text{REQUIRED*} wide_field" onkeypress="if (!key_pressed(event,9)) ensure_next_field(this);" id="{NAME_STUB*}{I*}" name="{NAME_STUB*}{I*}"{+START,IF_PASSED,MAXLENGTH} maxlength="{MAXLENGTH*}"{+END}>{DEFAULT*}</textarea>
	<input type="hidden" name="label_for__{NAME_STUB*}{I*}" value="{PRETTY_NAME*}" />
</div>
