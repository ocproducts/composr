<div class="constrain_field">
	<input onkeydown="if (!key_pressed(event,[null,'-','0','1','2','3','4','5','6','7','8','9','.'])) return false; return null;" tabindex="{TABINDEX*}" class="input_integer{REQUIRED*}"{+START,IF_NON_PASSED,MAXLENGTH} type="number" maxlength="30"{+END}{+START,IF_PASSED,MAXLENGTH} type="text" maxlength="{MAXLENGTH*}" size="{MAXLENGTH*}"{+END} id="{NAME*}" name="{NAME*}" value="{DEFAULT*}" />
</div>

