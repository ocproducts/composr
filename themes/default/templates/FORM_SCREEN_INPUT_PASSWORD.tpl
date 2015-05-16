<div class="constrain_field">
	{+START,IF,{$MATCH_KEY_MATCH,:join}}
		<div style="display: none" onmouseover="if (typeof this.parentNode.title!='undefined') this.parentNode.title=''; if (typeof window.activate_tooltip!='undefined') activate_tooltip(this,event,'{!PASSWORD_STRENGTH}','auto');" id="password_strength_{NAME*}" class="password_strength">
			<div class="password_strength_inner"></div>
		</div>
	{+END}

	<input onchange="password_strength(this);" size="30" maxlength="255" tabindex="{TABINDEX*}" class="input_password{REQUIRED*}" type="password" id="{NAME*}" name="{NAME*}" value="{VALUE*}" />
</div>

