{+START,IF,{$NEQ,{_NUM_IN_QUEUE},0}}
	<p>{!NEWSLETTER_DRIP_SEND_QUEUE,{NUM_IN_QUEUE*},{ETA*}}</p>

	{+START,IF,{PAUSED}}
		<p>{!CURRENTLY_PAUSED}</p>

		<form action="{UPDATE_URL*}" method="post">
			{$INSERT_SPAMMER_BLACKHOLE}

			<input type="hidden" name="unpause" value="1" />

			<input class="button_screen_item buttons__proceed" type="submit" value="{!UNPAUSE}" />
		</form>
	{+END}
{+END}
