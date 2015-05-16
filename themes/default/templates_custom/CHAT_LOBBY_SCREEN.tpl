{TITLE}

<h2>{!SELECT_CHATROOM}</h2>

<ul role="navigation" class="actions_list" id="rooms">
	<li class="vertical_alignment"><img aria-busy="true" src="{$IMG*,loading}" title="{!LOADING}" alt="{!LOADING}" /> <span>{!LOADING}</span></li>
</ul>

{+START,IF_NON_EMPTY,{SETEFFECTS_LINK}}
	<h2>{!ADVANCED_ACTIONS}</h2>

	<ul role="navigation" class="actions_list">
		<li>{SETEFFECTS_LINK}</li>
	</ul>
{+END}

<script>
// <![CDATA[
function on_login_completed_lobby()
{
	con.send(con.getPacketHelper().createPresence());

	mucMan.getRoomList(function(mucMan, rooms) {
		var rooms_ul=document.getElementById('rooms');
		set_inner_html(rooms_ul,'');
		for (var i=0;i<rooms.length;i++)
		{
			var date=new Date().getHours()+':'+((new Date().getMinutes()<10)?'0':'')+new Date().getMinutes();
			var room_name=rooms[i].name.replace(/ \(.*/,'');
			set_inner_html(rooms_ul,"<li><a href=\""+"{CHATROOM_URL*;/}".replace(/room_id/,room_name)+"\">"+room_name+"<\/a> ("+"{!STATIC_USERS_ONLINE;/}".replace('\{1}',date).replace('\{2}','<span id=\"usernames_'+room_name+'\">(loading)<\/span>')+")<\/li>",true);
			rooms[i].createState().getParticipants(
				function(room, participants) {
					var inThere='';
					for (var i=0;i<participants.length;i++)
					{
						var username=participants[i].realJid.replace(/\./g,' ').replace(/@.*/,'');
						if (inThere!='') inThere=inThere+', ';
						inThere=inThere+"<a href=\"{$BASE_URL*;/}/site/index.php?page=members&amp;type=view&amp;id="+escape_html(username)+"\">"+escape_html(username)+"<\/a>";
					}
					if (inThere=='') inThere='none';
					set_inner_html(document.getElementById('usernames_'+room_name), inThere);
				}
			);
		}
	});

	// Add friends
	var roster=Xmpp4Js.Roster.Roster.getInstanceFor(con);
	{+START,LOOP,FRIENDS}
		roster.createEntry('{$REPLACE;/, ,.,{USERNAME}}@{$DOMAIN*}', '{$DISPLAYED_USERNAME;/,{USERNAME}}', ['{$SITE_NAME;/}'] );
	{+END}
}

add_event_listener_abstract(window,'load',function() {
	xmpp_connect('{$REPLACE;/, ,.,{$USERNAME}}' ,'{PASSWORD_HASH;/}', on_login_completed_lobby);
});
// ]]>
</script>

<h2>Connecting via XMPP (Jabber)</h2>

<p>You can connect to our chat room via a desktop XMPP (Jabber) client. We've made it pretty easy:</p>
<ol>
	<li>Install a good XMPP client. <a href="http://psi-im.org/">Psi</a> works perfectly. We also know Apple iChat and Adium work, but their chat room creation features don't work. Jabberfox does not work at all.</li>
	<li>Connect as <kbd>{$REPLACE*, ,.,{$USERNAME}}@{$DOMAIN*}</kbd>, using the same password you log into {$SITE_NAME*} with (usernames are the same as on this site, except spaces are replaced with dots, and <kbd>@{$DOMAIN*}</kbd> is put on the end). Note that your login user looks like an e-mail address, but we should note that it won't work as one.</li>
	<li>If it makes you specify a server, say <kbd>{$DOMAIN*}</kbd>.</li>
	<li>If there is an option to allow plain-text authentication, make sure it is enabled.</li>
	<li>You will find the above configured chat rooms in the XMPP software's 'Service Discovery'/'Discovery browser'.</li>
</ol>

<p>Note that the web chat rooms won't load up if you're logged on with a desktop client.</p>

<h3>Instant messaging</h3>

<p>We have automatically added all your friends on {$SITE_NAME*} as contacts on XMPP, so when you login you will see them. To talk to them directly all you need to do is to convince them to install and run XMPP software.</p>
