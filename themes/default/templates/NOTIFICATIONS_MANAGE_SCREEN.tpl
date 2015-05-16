{TITLE}

<form title="{!NOTIFICATIONS}" method="post" action="{ACTION_URL*}">
	{$INSERT_SPAMMER_BLACKHOLE}

	<div>
		{INTERFACE}

		<p class="proceed_button">
			<input type="submit" class="buttons__save button_screen" value="{!SAVE}" />
		</p>
	</div>
</form>

{+START,IF,{$NEQ,{$ZONE},adminzone}}
	<hr class="spaced_rule" />

	<h2>{!NOTIFICATION_SOUND}</h2>

	<form title="{!NOTIFICATION_SOUND}" action="#" method="post">
		<p>
			<label for="sound_on">{!ENABLE_NOTIFICATION_SOUND} <input checked="checked" onclick="set_cookie('sound','on');" type="radio" name="sound" id="sound_on" /></label>
			<label for="sound_off">{!DISABLE_NOTIFICATION_SOUND} <input onclick="set_cookie('sound','off');" type="radio" name="sound" id="sound_off" /></label>
		</p>
	</form>
	<script>// <![CDATA[
		document.getElementById('sound_'+read_cookie('sound','on')).checked=true;
	//]]></script>
{+END}
