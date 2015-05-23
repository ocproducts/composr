<form title="{!PRIMARY_PAGE_FORM}"{+START,IF_NON_PASSED_OR_FALSE,GET} method="post" action="{URL*}"{+END}{+START,IF_PASSED_AND_TRUE,GET} method="get" action="{$URL_FOR_GET_FORM*,{URL}}"{+END}>
	{+START,IF_NON_PASSED_OR_FALSE,GET}{$INSERT_SPAMMER_BLACKHOLE}{+END}

	{+START,IF_PASSED_AND_TRUE,GET}{$HIDDENS_FOR_GET_FORM,{URL}}{+END}

	<p class="lonely_label"><label for="licence">{!LICENCE}:</label></p>
	<div class="constrain_field">
		<textarea readonly="readonly" class="purchase_licence" id="licence" name="licence" cols="50" rows="11">{LICENCE*}</textarea>
	</div>

	<p class="purchase_button">
		<input onclick="disable_button_just_clicked(this);" class="buttons__yes button_screen" type="submit" value="{!I_AGREE}" />
	</p>
</form>
