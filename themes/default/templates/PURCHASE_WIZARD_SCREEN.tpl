<div data-view="PurchaseWizardScreen">
{TITLE}

{+START,IF_NON_EMPTY,{URL}}
<form title="{!PRIMARY_PAGE_FORM}"{+START,IF_NON_PASSED_OR_FALSE,GET} method="post" enctype="multipart/form-data" action="{URL*}"{+END}{+START,IF_PASSED_AND_TRUE,GET} method="get" action="{$URL_FOR_GET_FORM*,{URL}}"{+END} autocomplete="off" class="js-form-primary">
	{+START,IF_NON_PASSED_OR_FALSE,GET}{$INSERT_SPAMMER_BLACKHOLE}{+END}

	{+START,IF_PASSED_AND_TRUE,GET}{$HIDDENS_FOR_GET_FORM,{URL}}{+END}
{+END}

<div class="purchase_screen_contents">
	{CONTENT}
</div>

{+START,IF_NON_EMPTY,{URL}}
	<p class="purchase_button">
		<input id="proceed_button" class="button_screen buttons__proceed js-click-do-form-submit" accesskey="u"{+START,IF,{$JS_ON}} type="button"{+END}{+START,IF,{$NOT,{$JS_ON}}} type="submit"{+END} value="{!PROCEED}" />
	</p>
</form>
{+END}
</div>