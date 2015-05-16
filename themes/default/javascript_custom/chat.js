if (typeof window.has_focus=='undefined')
{
	window.has_focus=true;
}
add_event_listener_abstract(window,'blur',function() { window.has_focus=false; });
add_event_listener_abstract(window,'focus',function() { window.has_focus=true; });

function play_sound_url(url) // Used for testing different sounds
{
	if (typeof window.soundManager=='undefined') return;

	var base_url=((url.indexOf('data_custom')==-1)&&(url.indexOf('uploads/')==-1))?'{$BASE_URL_NOHTTP;}':'{$CUSTOM_BASE_URL_NOHTTP;}';
	window.soundManager.destroySound('temp');
	window.soundManager.createSound('temp',base_url+'/'+url);
	window.soundManager.play('temp');
}

function play_chat_sound(sID,for_member)
{
	if (typeof window.soundManager=='undefined') return;

	var play_sound=window.document.getElementById('play_sound');

	if ((play_sound) && (!play_sound.checked)) return;

	if (for_member)
	{
		var override=window.soundManager.getSoundById(sID+'_'+for_member,true);
		if (override)
		{
			sID=sID+'_'+for_member;
		}
	}

	window.soundManager.play(sID);
}

function chat_load(room_id)
{
	document.getElementById("post").focus();

	manage_scroll_height(document.getElementById('post'));

	window.con.addPacketListener(
		function(msg) {
			// load extensions that are present in the packet using our ExtensionProvider
			msg.loadExtensions(window.extProvider);

			chatMessageHandler(null,msg);
		},
		new window.Xmpp4Js.PacketFilter.PacketTypeFilter( "groupchat" )
	);

	play_chat_sound('you_connect');
}

function chatMessageHandler(chat, messagePacket)
{
	if( messagePacket.hasContent() )
	{
		addChatMessage(messagePacket.getFrom().replace(/.*\//,'').replace(/\./g,' '),messagePacket.getBody(),messagePacket.getDate());
	}
}

function addChatMessage(username,body,_date)
{
	var messages=document.getElementById('messages_window');
	if (!_date)
		_date=new Date();
	var date=_date.toLocaleString();
	set_inner_html(messages,"<div class=\"chat_message\"><a href=\"{$BASE_URL*}/site/index.php?page=members&amp;type=view&amp;id="+escape_html(username)+"\"><img class=\"chat_avatar\" src=\"{$FIND_SCRIPT*,get_avatar}?id="+window.encodeURIComponent(username)+keep_stub(false)+"\" alt=\"{!AVATAR}\" title=\"\" /></a><div><span class=\"chat_message_by\">By <a href=\"{$BASE_URL*}/site/index.php?page=members&amp;type=view&amp;id="+escape_html(username)+"\">"+escape_html(username)+"</a></span> <span class=\"associated_details\">("+escape_html(date)+")</span></div><blockquote>"+escape_html(body)+"</blockquote></div>"+get_inner_html(messages));
}

// Post a chat message
function chat_post(event,current_room_id,field_name)
{
	var message=document.getElementById(field_name).value;
	if (message=='') return false;
	window.room.sendText( message );
	document.getElementById(field_name).value='';

	play_chat_sound('message_sent');

	return false;
}

function xmpp_connect(username,password,onLoginCompleted)
{
	window.extProvider = new window.Xmpp4Js.Ext.PacketExtensionProvider();
	window.extProvider.register( window.Xmpp4Js.Ext.Muc.XMLNS, window.Xmpp4Js.Ext.Muc );
	window.extProvider.register( window.Xmpp4Js.Ext.MucUser.XMLNS, window.Xmpp4Js.Ext.MucUser );
	window.extProvider.register( window.Xmpp4Js.Ext.Error.XMLNS, window.Xmpp4Js.Ext.Error );

	var sp = new window.Xmpp4Js.Packet.StanzaProvider();
	sp.registerDefaultProviders();

	window.con = new window.Xmpp4Js.Connection( {
		transport: {
			clazz: window.Xmpp4Js.Transport.BOSH,
			//endpoint: "{$FIND_SCRIPT#,xmpp_proxy}"
			endpoint: "http://{$DOMAIN#}:5280/http-bind/" // Same origin policy support
		},
		stanzaProvider: sp
	});
	window.con.on("connect", function() { onConnectForLogin(username,password,onLoginCompleted) }, this, {single: true});
	window.con.on("error", onConnectError, this, {single: true});
	window.con.connect( "{$DOMAIN;}" );
}

function onConnectError()
{
	if (typeof window.mucMan=='undefined')
		window.fauxmodal_alert('Error connecting to XMPP server.');
}

function onConnectForLogin(username,password,onLoginCompleted)
{
	var loginFlow = new window.Xmpp4Js.Workflow.Login({
		con: window.con
	});

	loginFlow.on("success", onLoginCompleted );
	loginFlow.on("failure", onConnectError );

	loginFlow.start( "plaintext", username, password );

	window.mucMan = window.Xmpp4Js.Muc.MucManager.getInstanceFor( window.con, "conference.{$DOMAIN;}", window.extProvider );

	add_event_listener_abstract(window,'unload',function() {
		if (window.con.isConnected()) // Clean shutdown
		{
			if (window.room) window.room.part();
			window.con.close();
		}
	});

	window.setInterval( function() {
		if (!window.con.isConnected()) // Auto reconnect on errors
		{
			xmpp_connect(username,password,onLoginCompleted);
		}
	} , 10000 );
}
