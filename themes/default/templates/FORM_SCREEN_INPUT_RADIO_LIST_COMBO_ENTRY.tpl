<p>
	<label for="j_{NAME|*}_other"><input tabindex="{TABINDEX*}" class="input_radio" type="radio" id="j_{NAME|*}_other" name="{NAME*}" value=""{+START,IF_NON_EMPTY,{VALUE}} checked="checked"{+END} onchange="document.getElementById('j_{NAME|*}_other_custom').disabled=(!this.checked);" /> {!OTHER}</label>
	<br />
	<label for="j_{NAME|*}_other_custom" class="accessibility_hidden">{!TEXT}</label>
	<input tabindex="{TABINDEX*}" type="text" id="j_{NAME|*}_other_custom" name="{NAME*}_custom" value="{VALUE*}"{+START,IF_EMPTY,{VALUE}} disabled="disabled"{+END} />
</p>

<script>// <![CDATA[
	document.getElementById('j_{NAME|*}_other').onchange();
//]]></script>
