<div data-tpl-chat="chatSitewideImPopup">
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

{CHAT_SOUND}
</div>