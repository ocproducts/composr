<form title="{!PRIMARY_PAGE_FORM}"{+START,IF_NON_PASSED_OR_FALSE,GET} method="post" action="{URL*}"{+END}{+START,IF_PASSED_AND_TRUE,GET} method="get" action="{$URL_FOR_GET_FORM*,{URL}}"{+END}>
	{+START,IF_NON_PASSED_OR_FALSE,GET}{$INSERT_SPAMMER_BLACKHOLE}{+END}

	{+START,IF_PASSED_AND_TRUE,GET}{$HIDDENS_FOR_GET_FORM,{URL}}{+END}

	<p>{!AGREEMENT_PROCESS}</p>

	<p class="lonely_label">{!AGREEMENT}:</p>

	<div class="purchase_licence">{LICENCE*}</div>

	<p>
		<input type="checkbox" id="confirm" name="confirm" value="1" onclick="document.getElementById('proceed_button').disabled=!this.checked;" /><label for="confirm">{!I_AGREE}</label>
	</p>

	<p>
		{+START,IF,{$JS_ON}}
			<button onclick="disable_button_just_clicked(this); window.location='{$PAGE_LINK;*,:}'; return false;" class="buttons__no button_screen">{!I_DISAGREE}</button>
		{+END}

		<input accesskey="u" onclick="disable_button_just_clicked(this);" class="buttons__yes button_screen" type="submit" value="{!PROCEED}"{+START,IF,{$JS_ON}} disabled="disabled"{+END} id="proceed_button" />
	</p>
</form>
