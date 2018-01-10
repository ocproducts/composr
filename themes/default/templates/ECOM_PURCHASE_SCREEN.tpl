{$REQUIRE_JAVASCRIPT,ecommerce}

<div data-require-javascript="ecommerce" data-view="PurchaseWizardScreen">
	{TITLE}

	{+START,IF_NON_EMPTY,{URL}}
	<form title="{!PRIMARY_PAGE_FORM}"{+START,IF_NON_PASSED_OR_FALSE,GET} method="post" enctype="multipart/form-data" action="{URL*}"{+END}{+START,IF_PASSED_AND_TRUE,GET} method="get" action="{$URL_FOR_GET_FORM*,{URL}}"{+END} autocomplete="off" class="js-form-primary">
		{+START,IF_NON_PASSED_OR_FALSE,GET}{$INSERT_SPAMMER_BLACKHOLE}{+END}

		{+START,IF_PASSED_AND_TRUE,GET}{$HIDDENS_FOR_GET_FORM,{URL}}{+END}
	{+END}

	<div class="purchase-screen-contents">
		{CONTENT}
	</div>

	{+START,IF_NON_EMPTY,{URL}}
		<p class="purchase-button">
			<input id="proceed_button" class="button-screen {ICON*} js-click-do-form-submit" accesskey="u" type="button" value="{SUBMIT_NAME*}" />
		</p>
	</form>
	{+END}
</div>
