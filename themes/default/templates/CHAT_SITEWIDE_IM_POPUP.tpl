{CONTENT}

<form class="chat_sound_effects_checkbox inline" title="{!SOUND_EFFECTS}" action="index.php" method="post" autocomplete="off">
	{$INSERT_SPAMMER_BLACKHOLE}

	<p>
		<label for="play_sound">{!SOUND_EFFECTS}:</label> <input type="checkbox" id="play_sound" name="play_sound" checked="checked" />
	</p>
</form>

<ul class="actions_list">
	<li>{!GOTO_CHAT_LOBBY_FOR_MORE,{$PAGE_LINK*,_SEARCH:chat}}</li>
</ul>

<script>// <![CDATA[
	window.detect_if_chat_window_closed_checker=window.setInterval(function() {
		if (typeof detect_if_chat_window_closed!='undefined') detect_if_chat_window_closed();
	},5);
//]]></script>

{CHAT_SOUND}
<script>
// <![CDATA[
	add_event_listener_abstract(window,'load',prepare_chat_sounds);
// ]]>
</script>
