{$REQUIRE_JAVASCRIPT,chat}
{$SET,emoticons_popup_url,{$FIND_SCRIPT,emoticons}?field_name=post_{CHATROOM_ID}{$KEEP,0,1}}
<div id="room_{CHATROOM_ID*}" class="chat_lobby_convos_area" data-tpl="chatLobbyImArea" data-tpl-params="{+START,PARAMS_JSON,CHATROOM_ID,emoticons_popup_url}{_*}{+END}">
	<form title="{!MESSAGE}" action="{MESSAGES_PHP*}?action=post" method="post" autocomplete="off">
		{$INSERT_SPAMMER_BLACKHOLE}

		<div class="im_post_bits">
			<label class="accessibility_hidden" for="post_{CHATROOM_ID*}">{!MESSAGE}</label>
			<textarea class="input_required im_post_field" onkeypress="if ($cms.dom.keyPressed(event, 'Enter')) { cancel_bubbling(event); return false; } return true;" onkeyup="{+START,IF,{$NOT,{$MOBILE}}}manage_scroll_height(this); {+END}if ($cms.dom.keyPressed(event, 'Enter')) { set_cookie('last_chat_msg_{CHATROOM_ID;*}',''); return chat_post(event,{CHATROOM_ID*},'post_{CHATROOM_ID*}','',''); return true; } else { set_cookie('last_chat_msg_{CHATROOM_ID;*}',this.value); } " id="post_{CHATROOM_ID*}" name="post_{CHATROOM_ID*}" cols="30" rows="1"></textarea>

			{+START,IF,{$AND,{$CNS},{$JS_ON}}}
				<a rel="nofollow" class="horiz_field_sep js-click-open-chat-emoticons-popup" href="#!" title="{!EMOTICONS} {!LINK_NEW_WINDOW}">
					<img alt="" src="{$IMG*,icons/16x16/editor/insert_emoticons}" srcset="{$IMG*,icons/32x32/editor/insert_emoticons} 2x" />
				</a>
			{+END}

			<input class="button_micro buttons__send js-click-chatroom-chat-post" type="button" value="{!MAKE_POST_SHORT}" />
		</div>

		<div class="chat_lobby_convos_area_bar">
			<h3>{!PARTICIPANTS}</h3>

			<div class="chat_lobby_convos_area_participants" id="participants__{CHATROOM_ID*}">
				<em class="loading">{!LOADING}</em>
			</div>
			<div class="im_close_button">
				<input id="close_button_{CHATROOM_ID*}" class="button_micro buttons__clear" type="button" value="{!END_CHAT}" onclick="close_chat_conversation({CHATROOM_ID%});" />
			</div>
		</div>

		<div class="chat_lobby_convos_area_main">
			<div class="chat_lobby_convos_area_messages messages_window" id="messages_window_{CHATROOM_ID*}"></div>
		</div>
	</form>
</div>

