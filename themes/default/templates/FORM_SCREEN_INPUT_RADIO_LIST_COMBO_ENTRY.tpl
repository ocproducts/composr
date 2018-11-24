<p data-tpl="formScreenInputRadioListComboEntry" data-tpl-params="{+START,PARAMS_JSON,NAME}{_*}{+END}">
	<label for="j-{NAME|*}-other">
		<input tabindex="{TABINDEX*}" class="input-radio js-change-toggle-other-custom-input" type="radio" id="j-{NAME|*}-other" name="{NAME*}"{+START,IF_NON_EMPTY,{VALUE}} checked="checked"{+END} />
		{!OTHER}
	</label>
	<br />
	<label for="j-{NAME|*}-other-custom" class="accessibility-hidden">{!TEXT}</label>
	<input tabindex="{TABINDEX*}" type="text" id="j-{NAME|*}-other-custom" class="form-control" name="{NAME*}_custom" value="{VALUE*}"{+START,IF_EMPTY,{VALUE}} disabled="disabled"{+END} />
</p>
