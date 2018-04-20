{$REQUIRE_JAVASCRIPT,chat}

<div class="chat-lobby-im-participant" data-tpl="chatLobbyImParticipant">
	<div class="float-surrounder">
		{+START,IF_NON_EMPTY,{AVATAR_URL}}
			<img class="chat-participant-avatar" style="display: block" id="avatar--{ID*}" src="{$ENSURE_PROTOCOL_SUITABILITY*,{AVATAR_URL}}" alt="{!AVATAR}" />
		{+END}

		<a target="_blank" title="{!VIEW_PROFILE}: {USERNAME*} {!LINK_NEW_WINDOW}" href="{PROFILE_URL*}">{USERNAME*}</a>
		<span id="participant-online--{CHATROOM_ID*}--{ID*}"><em>{ONLINE*}</em></span>
	</div>
	<div class="associated-details">
		<p class="lonely-label">{!ACTIONS}:</p>
		<nav>
			<ul class="actions-list-super-compact">
				<li id="friend--{ID*}">
					{+START,INCLUDE,ICON}NAME=buttons/proceed2{+END} <a class="js-click-hide-self" target="_blank" title="{!MAKE_FRIEND} {!LINK_NEW_WINDOW}" href="{MAKE_FRIEND_URL*}">{!MAKE_FRIEND}</a>
				</li>
				<li id="block--{ID*}">
					{+START,INCLUDE,ICON}NAME=buttons/proceed2{+END} <a target="_blank" title="{!BLOCK_MEMBER} {!LINK_NEW_WINDOW}" href="{BLOCK_MEMBER_URL*}">{!BLOCK_MEMBER}</a>
				</li>
			</ul>
		</nav>
	</div>
</div>
