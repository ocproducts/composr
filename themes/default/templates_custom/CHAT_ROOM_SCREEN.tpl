{TITLE}

{+START,IF_NON_EMPTY,{INTRODUCTION}}<p>{INTRODUCTION}</p>{+END}

{CHAT_SOUND}

<div class="chat_you_are">{!LOGGED_IN_AS,{YOUR_NAME*}}</div>

<h2>{CHATROOM_ID*}</h2>

<div class="float_surrounder">
	<div class="left">
		<form title="{!MESSAGE}" onsubmit="return false;" action="#" method="post" style="display: inline;">
			{$INSERT_SPAMMER_BLACKHOLE}

			<div style="display: inline;">
				<p style="display: none;"><label for="post">{!MESSAGE}</label></p>
				<textarea class="input_text_required"{+START,IF,{$NOT,{$MOBILE}}} onkeyup="manage_scroll_height(this);"{+END} onkeypress="if (enter_pressed(event)) return chat_post(event,'{CHATROOM_ID;*}','post'); return true;" id="post" name="message" cols="42" rows="1"></textarea>
			</div>
		</form>
	</div>
	<div class="left">
		<form title="{SUBMIT_VALUE*}" action="{MESSAGES_PHP*}?action=post&amp;room_id={CHATROOM_ID*}" method="post" style="display: inline;">
			<input type="button" class="buttons__send button_micro" name="post_now" onclick="return chat_post(event,'{CHATROOM_ID;*}','post');" value="{SUBMIT_VALUE*}" />
		</form>
		{+START,IF,{$CNS}}
			<span class="horiz_field_sep associated_link"><a tabindex="6" href="#" onclick="window.faux_open(maintain_theme_in_link('{$FIND_SCRIPT;*,emoticons}?field_name=post{$KEEP;*}'),'emoticon_chooser','width=300,height=320,status=no,resizable=yes,scrollbars=no'); return false;">{!EMOTICONS_POPUP}</a></span>
		{+END}
	</div>
	<div class="right">
		<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray('chat_comcode_panel');"><img id="e_chat_comcode_panel" src="{$IMG*,1x/trays/expand}" srcset="{$IMG*,2x/trays/expand} 2x" alt="{!CHAT_TOGGLE_COMCODE_BOX}" title="{!CHAT_TOGGLE_COMCODE_BOX}" /></a>
	</div>
</div>

<div style="display: {$JS_ON,none,block}" class="chat_comcode_panel">
	<form title="{!SOUND_EFFECTS}" action="{OPTIONS_URL*}" method="post" class="inline">
		<div>
			<label for="play_sound">{!SOUND_EFFECTS}:</label> <input type="checkbox" id="play_sound" name="play_sound" checked="checked" />
		</div>
	</form>
</div>

<div class="messages_window"><div class="messages_window_full_chat" id="messages_window"></div></div>

<p>
	{!USERS_IN_CHATROOM} <span id="chat_members_update" class="vertical_alignment"><img aria-busy="true" src="{$IMG*,loading}" title="{!LOADING}" alt="{!LOADING}" /> <span>{!LOADING}</span></span>
</p>

<script>// <![CDATA[
function on_login_completed_room()
{
	var messages=document.getElementById('messages_window');
	set_inner_html(messages,'');

	chat_load('{CHATROOM_ID%}');
	window.con.jid='{$REPLACE;/, ,.,{$USERNAME}}@{$DOMAIN;*}';
	window.room=mucMan.getRoom( "{CHATROOM_ID;/}" ).createState();
	window.room.join('{$REPLACE;/, ,.,{$USERNAME}}');
	function loadRoomMembers()
	{
		window.room.getParticipants(
			function(room, participants) {
				var inThere='';
				for (var i=0;i<participants.length;i++)
				{
					var username=participants[i].realJid.replace(/\./g,' ').replace(/@.*/,'');
					if (inThere!='') inThere=inThere+', ';
					inThere=inThere+"<a href=\"{$BASE_URL*}/site/index.php?page=members&amp;type=view&amp;id="+escape_html(username)+"\">"+escape_html(username)+"<\/a>";
				}
				if (inThere=='') inThere='none';

				set_inner_html(document.getElementById("chat_members_update"), inThere);
			}
		);
	}
	window.setInterval(loadRoomMembers, 15000);
	window.setTimeout(loadRoomMembers, 5000);
}

add_event_listener_abstract(window,'load',function() {
	xmpp_connect("{$REPLACE;/, ,.,{$USERNAME}}","{PASSWORD_HASH;/}",on_login_completed_room);
});
// ]]></script>

{+START,IF_NON_EMPTY,{LINKS}}
	<p class="lonely_label">{!ACTIONS}:</p>
	<ul role="navigation" class="actions_list">
		{+START,LOOP,LINKS}
			{+START,IF_NON_EMPTY,{_loop_var}}
				<li>{_loop_var}</li>
			{+END}
		{+END}
	</ul>
{+END}
