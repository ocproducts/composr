{$REQUIRE_JAVASCRIPT,core_form_interfaces}

<div data-tpl="formScreenInputUsernameMulti" class="multi_field">
	<div class="accessibility_hidden"><label for="{NAME_STUB*}{I*}">{PRETTY_NAME*}</label></div>
	<input {+START,IF,{$MOBILE}} autocorrect="off"{+END} autocomplete="off" maxlength="255" tabindex="{TABINDEX*}" class="{+START,IF,{NEEDS_MATCH}}input_username {+END}input_line{REQUIRED*} wide_field js-focus-update-ajax-member-list js-keyup-update-ajax-member-list js-change-ensure-next-field js-keypress-ensure-next-field" type="text" id="{NAME_STUB*}{I*}" name="{NAME_STUB*}{I*}" value="{DEFAULT*}" />
	<input type="hidden" name="label_for__{NAME_STUB*}{I*}" value="{PRETTY_NAME*}" />
</div>
