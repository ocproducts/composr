{$REQUIRE_JAVASCRIPT,core_form_interfaces}

<div data-tpl="formScreenInputPassword" data-tpl-params="{+START,PARAMS_JSON,VALUE,NAME}{_*}{+END}">
	{+START,IF,{$MATCH_KEY_MATCH,:join}}
		<div style="display: none" id="password_strength_{NAME*}" class="password_strength js-mouseover-activate-password-strength-tooltip">
			<div class="password_strength_inner"></div>
		</div>
	{+END}

	<input {+START,IF,{$EQ,{NAME},edit_password}} autocomplete="off"{+START,IF,{$MOBILE}} autocorrect="off"{+END}{+END} size="27" maxlength="255" tabindex="{TABINDEX*}" class="input_password{REQUIRED*} js-input-change-check-password-strength" type="password" id="{NAME*}" name="{NAME*}" value="{VALUE*}" />
</div>
