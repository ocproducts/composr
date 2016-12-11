<div class="search_option float_surrounder">
	{+START,IF_NON_PASSED_OR_FALSE,HAS_RANGE}
		<label for="sd_{NAME*}">{DISPLAY*}:</label>

		<input size="5" maxlength="255" class="search_option_value" onkeydown="if (!key_pressed(event,[null,'-','0','1','2','3','4','5','6','7','8','9'])) return false; return null;" type="number" id="sd_{NAME*}" name="{NAME*}" value="{SPECIAL*}" />
	{+END}

	{+START,IF_PASSED_AND_TRUE,HAS_RANGE}
		<label for="sd_{NAME*}_from">{DISPLAY*}<span class="accessibility_hidden">, {!FROM}</span>:</label>
		<label for="sd_{NAME*}_to" class="accessibility_hidden">>{DISPLAY*}, {!TO}:</label>

		<input size="5" maxlength="255" class="search_option_value" onkeydown="if (!key_pressed(event,[null,'-','0','1','2','3','4','5','6','7','8','9'])) return false; return null;" type="number" id="sd_{NAME*}_from" name="{NAME*}_from" value="{$PREG_REPLACE*,;.*$,,{SPECIAL}}" />

		&ndash;

		<input size="5" maxlength="255" class="search_option_value" onkeydown="if (!key_pressed(event,[null,'-','0','1','2','3','4','5','6','7','8','9'])) return false; return null;" type="number" id="sd_{NAME*}_to" name="{NAME*}_to" value="{$PREG_REPLACE*,^.*;,,{SPECIAL}}" />
	{+END}
</div>
