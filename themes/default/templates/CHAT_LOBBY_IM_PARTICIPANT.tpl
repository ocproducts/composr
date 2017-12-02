{$REQUIRE_JAVASCRIPT,chat}

<div class="chat-lobby-im-participant" data-tpl="chatLobbyImParticipant">
	<div class="float-surrounder">
		{+START,IF_NON_EMPTY,{AVATAR_URL}}
			<img class="chat-participant-avatar" style="display: block" id="avatar__{ID*}" src="{$ENSURE_PROTOCOL_SUITABILITY*,{AVATAR_URL}}" alt="{!AVATAR}" />
		{+END}

		<a target="_blank" title="{!VIEW_PROFILE}: {USERNAME*} {!LINK_NEW_WINDOW}" href="{PROFILE_URL*}">{USERNAME*}</a>
		<span id="participant_online__{CHATROOM_ID*}__{ID*}"><em>{ONLINE*}</em></span>
	</div>
	<div class="associated-details">
		<p class="lonely_label">{!ACTIONS}:</p>
		<nav>
			<ul class="actions_list_super_compact">
				<li id="friend__{ID*}">
					<a class="js-click-hide-self" target="_blank" title="{!MAKE_FRIEND} {!LINK_NEW_WINDOW}" href="{MAKE_FRIEND_URL*}">{!MAKE_FRIEND}</a>
				</li>
				<li id="block__{ID*}">
					<a target="_blank" title="{!BLOCK_MEMBER} {!LINK_NEW_WINDOW}" href="{BLOCK_MEMBER_URL*}">{!BLOCK_MEMBER}</a>
				</li>
			</ul>
		</nav>
	</div>
</div>
