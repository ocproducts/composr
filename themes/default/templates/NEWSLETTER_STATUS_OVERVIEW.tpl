{+START,IF,{$NEQ,{_NUM_IN_QUEUE},0}}
	<p>{!NEWSLETTER_DRIP_SEND_QUEUE,{NUM_IN_QUEUE*},{ETA*}}</p>

	{+START,IF,{PAUSED}}
		<p>{!CURRENTLY_PAUSED,{QUEUE_URL*}}</p>

		<form action="{UPDATE_URL*}" method="post">
			{$INSERT_SPAMMER_BLACKHOLE}

			<input type="hidden" name="set_pause" value="0" />

			<input class="button_screen_item buttons__proceed" type="submit" value="{!UNPAUSE}" />
		</form>
	{+END}

	{+START,IF,{$NOT,{PAUSED}}}
		<form action="{UPDATE_URL*}" method="post">
			{$INSERT_SPAMMER_BLACKHOLE}

			<input type="hidden" name="set_pause" value="1" />

			<input class="button_screen_item buttons__proceed" type="submit" value="{!PAUSE}" />
		</form>
	{+END}
{+END}
