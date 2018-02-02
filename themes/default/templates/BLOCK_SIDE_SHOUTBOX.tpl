{$REQUIRE_JAVASCRIPT,chat}

{$SET,block_call_url,{$FACILITATE_AJAX_BLOCK_CALL,{BLOCK_PARAMS}}}
{$SET,ajax_block_side_shoutbox_wrapper,ajax-block-side-shoutbox-wrapper-{$RAND%}}
<div id="{$GET*,ajax_block_side_shoutbox_wrapper}" class="box-wrapper" data-require-javascript="chat" data-tpl="blockSideShoutbox" data-tpl-params="{+START,PARAMS_JSON,ajax_block_side_shoutbox_wrapper,block_call_url}{_*}{+END}">
	<section class="box box---block-side-shoutbox"><div class="box-inner">
		<h3>{!SHOUTBOX}</h3>

		{MESSAGES}

		<form title="{!SHOUTBOX}" class="js-form-submit-side-shoutbox" target="_self" action="{URL*}" method="post" autocomplete="off">
			{$INSERT_SPAMMER_BLACKHOLE}

			<div>
				<p class="accessibility-hidden"><label for="shoutbox-message">{!MESSAGE}</label></p>
				<p><input autocomplete="off" type="text" id="shoutbox-message" name="shoutbox_message" alt="{!MESSAGE}" class="wide-field" /></p>
			</div>

			<p class="proceed-button">
				<input type="submit" value="{!SEND_MESSAGE}" class="button-screen-item buttons--send" />
			</p>
		</form>
	</div></section>
</div>
