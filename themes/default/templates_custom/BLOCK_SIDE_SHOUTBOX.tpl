{$REQUIRE_JAVASCRIPT,chat}
{$REQUIRE_JAVASCRIPT,shoutr}
{$REQUIRE_CSS,shoutbox}

{+START,IF,{$HAS_ACTUAL_PAGE_ACCESS,chat}}
	<section class="box box---block-side-shoutbox" role="marquee" data-tpl="blockSideShoutbox" data-tpl-params="{+START,PARAMS_JSON,CHATROOM_ID,LAST_MESSAGE_ID}{_*}{+END}">
		<div class="box-inner">
			<h3>{!SHOUTBOX}</h3>

			{MESSAGES}

			<form target="_self" action="{$EXTEND_URL*,{URL},posted=1}" method="post" title="{!SHOUTBOX}" autocomplete="off">
				{$INSERT_SPAMMER_BLACKHOLE}

				<div>
					<p class="accessibility-hidden"><label for="shoutbox-message">{!MESSAGE}</label></p>
					<p><input autocomplete="off" type="text" id="shoutbox-message" name="shoutbox_message" alt="{!MESSAGE}" class="wide-field" /></p>
				</div>

				<div class="float-surrounder">
					<button class="button-screen-item buttons--send js-click-btn-send-message" style="margin: 0" type="submit">{+START,INCLUDE,ICON}NAME=buttons/send{+END} Send</button>
					<button class="button-screen-item spare--8 js-click-btn-shake-screen" style="margin: 0" type="submit" title="Shake the screen of all active website visitors">{+START,INCLUDE,ICON}NAME=spare/8{+END} Shake</button>
				</div>
			</form>
		</div>
	</section>
{+END}
