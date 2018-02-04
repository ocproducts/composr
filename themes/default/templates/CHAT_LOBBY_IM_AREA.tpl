{$REQUIRE_JAVASCRIPT,chat}
{$SET,emoticons_popup_url,{$FIND_SCRIPT,emoticons}?field_name=post_{CHATROOM_ID}{$KEEP,0,1}}
<div id="room-{CHATROOM_ID*}" class="chat-lobby-convos-area" data-tpl="chatLobbyImArea" data-tpl-params="{+START,PARAMS_JSON,CHATROOM_ID,emoticons_popup_url}{_*}{+END}">
	<form title="{!MESSAGE}" action="{MESSAGES_PHP*}?action=post" method="post" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		{+START,SET,posting_box}
			<div class="im-post-bits">
				<label class="accessibility-hidden" for="post_{CHATROOM_ID*}">{!MESSAGE}</label>
				<textarea class="input-required im-post-field js-keypress-eat-enter js-keyup-textarea-chat-post" id="post_{CHATROOM_ID*}" name="post_{CHATROOM_ID*}" cols="30" rows="1"></textarea>

				{+START,IF,{$CNS}}
					<a rel="nofollow" class="horiz-field-sep js-click-open-chat-emoticons-popup" href="#!" title="{!EMOTICONS_POPUP} {!LINK_NEW_WINDOW}"><img alt="{!EMOTICONS_POPUP}" width="16" height="16" src="{$IMG*,icons/editor/insert_emoticons}" /></a>
				{+END}

				<input class="button-micro buttons--send js-click-chatroom-chat-post" type="button" value="{!MAKE_POST_SHORT}" />
			</div>
		{+END}

		{+START,IF,{$EQ,{$CONFIG_OPTION,chat_message_direction},upwards}}
			{$GET,posting_box}
		{+END}

		<div class="chat-lobby-convos-area-bar">
			<h3>{!PARTICIPANTS}</h3>

			<div class="chat-lobby-convos-area-participants" id="participants--{CHATROOM_ID*}">
				<em class="loading">{!LOADING}</em>
			</div>
			<div class="im-close-button">
				<input id="close-button-{CHATROOM_ID*}" class="button-micro buttons--close js-click-close-chat-conversation" type="button" value="{!END_CHAT}" />
			</div>
		</div>

		<div class="chat-lobby-convos-area-main">
			<div class="chat-lobby-convos-area-messages messages-window" id="messages-window-{CHATROOM_ID*}"></div>
		</div>

		{+START,IF,{$EQ,{$CONFIG_OPTION,chat_message_direction},downwards}}
			{$GET,posting_box}
		{+END}
	</form>
</div>
