{$SET,ajax_block_main_newsletter_signup_wrapper,ajax_block_main_newsletter_signup_wrapper_{$RAND%}}

{$REQUIRE_JAVASCRIPT,checking}
{$REQUIRE_JAVASCRIPT,newsletter}

<div id="{$GET*,ajax_block_main_newsletter_signup_wrapper}" data-ajaxify="{ callUrl: '{$FACILITATE_AJAX_BLOCK_CALL;*,{BLOCK_PARAMS}}', callParamsFromTarget: ['.*'], targetsSelector: '#{$GET%,ajax_block_main_newsletter_signup_wrapper} form' }">
	{+START,IF_PASSED,MSG}
		<p>{MSG}</p>
	{+END}

	<section class="box box---block-main-newsletter-signup" data-require-javascript="['checking', 'newsletter']" data-tpl="blockMainNewsletterSignup" data-tpl-params="{+START,PARAMS_JSON,NID}{_*}{+END}"><div class="box-inner">
		<h3>{!NEWSLETTER}{$?,{$NEQ,{NEWSLETTER_TITLE},{!GENERAL}},: {NEWSLETTER_TITLE*}}</h3>

		<form class="js-form-submit-newsletter-check-email-field" title="{!NEWSLETTER}" action="{URL*}" method="post" autocomplete="off">
			{$INSERT_SPAMMER_BLACKHOLE}

			<p class="accessibility-hidden"><label for="baddress">{!EMAIL_ADDRESS}</label></p>

			<div>
				<input class="wide-field" id="baddress" name="address{NID*}" placeholder="{!EMAIL_ADDRESS}" />
			</div>

			<p class="proceed-button">
				<button class="button-screen-item" type="submit">{+START,INCLUDE,ICON}NAME=menu/site_meta/newsletters{+END} {!SUBSCRIBE}</button>
			</p>
		</form>
	</div></section>
</div>
