{$REQUIRE_JAVASCRIPT,chat}
{$REQUIRE_JAVASCRIPT,shoutr}
{$REQUIRE_CSS,shoutbox}

{+START,IF,{$HAS_ACTUAL_PAGE_ACCESS,chat}}
	<section class="box box___block_side_shoutbox" role="marquee" data-require-javascript="['chat', 'shoutr']" data-tpl="blockSideShoutbox" data-tpl-params="{+START,PARAMS_JSON,CHATROOM_ID,LAST_MESSAGE_ID}{_*}{+END}">
		<div class="box_inner">
			<h3>{!SHOUTBOX}</h3>

			{MESSAGES}

			<form target="_self" action="{$EXTEND_URL*,{URL},posted=1}" method="post" title="{!SHOUTBOX}" autocomplete="off">
				{$INSERT_SPAMMER_BLACKHOLE}

				<div>
					<p class="accessibility_hidden"><label for="shoutbox_message">{!MESSAGE}</label></p>
					<p><input autocomplete="off" type="text" id="shoutbox_message" name="shoutbox_message" alt="{!MESSAGE}" class="wide_field" /></p>
				</div>

				<div class="float-surrounder">
					<input class="button_screen_item buttons__send js-click-btn-send-message" style="margin: 0" type="submit" value="Send" />
					<input class="button_screen_item menu___generic_spare__8 js-click-btn-shake-screen" style="margin: 0" type="submit" title="Shake the screen of all active website visitors" value="Shake" />
				</div>
			</form>
		</div>
	</section>
{+END}
