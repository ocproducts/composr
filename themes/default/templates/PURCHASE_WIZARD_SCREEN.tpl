{TITLE}

{+START,IF_NON_EMPTY,{URL}}
<form title="{!PRIMARY_PAGE_FORM}"{+START,IF_NON_PASSED_OR_FALSE,GET} method="post" enctype="multipart/form-data" action="{URL*}"{+END}{+START,IF_PASSED_AND_TRUE,GET} method="get" action="{$URL_FOR_GET_FORM*,{URL}}"{+END} autocomplete="off">
	{+START,IF_NON_PASSED_OR_FALSE,GET}{$INSERT_SPAMMER_BLACKHOLE}{+END}

	{+START,IF_PASSED_AND_TRUE,GET}{$HIDDENS_FOR_GET_FORM,{URL}}{+END}
{+END}

<div class="purchase_screen_contents">
	{CONTENT}
</div>

{+START,IF_NON_EMPTY,{URL}}
	<p class="purchase_button">
		<input id="proceed_button" onclick="if (typeof this.form=='undefined') var form=window.form_submitting; else var form=this.form; return do_form_submit(form,event);" class="button_screen buttons__proceed" accesskey="u"{+START,IF,{$JS_ON}} type="button"{+END}{+START,IF,{$NOT,{$JS_ON}}} type="submit"{+END} value="{!PROCEED}" />
	</p>
</form>
{+END}

