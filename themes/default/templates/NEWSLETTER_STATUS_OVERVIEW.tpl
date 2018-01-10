{+START,IF,{$NEQ,{_NUM_IN_QUEUE},0}}
	<p>{!NEWSLETTER_DRIP_SEND_QUEUE,{NUM_IN_QUEUE*},{ETA*}}</p>

	{+START,IF,{PAUSED}}
		<p>{!CURRENTLY_PAUSED,{QUEUE_URL*}}</p>

		<form title="{!UNPAUSE}" action="{UPDATE_URL*}" method="post" autocomplete="off">
			{$INSERT_SPAMMER_BLACKHOLE}

			<input type="hidden" name="set_pause" value="0" />

			<input class="button-screen-item buttons--proceed" type="submit" value="{!UNPAUSE}" />
		</form>
	{+END}

	{+START,IF,{$NOT,{PAUSED}}}
		<form title="{!PAUSE}" action="{UPDATE_URL*}" method="post" autocomplete="off">
			{$INSERT_SPAMMER_BLACKHOLE}

			<input type="hidden" name="set_pause" value="1" />

			<input class="button-screen-item buttons--proceed" type="submit" value="{!PAUSE}" />
		</form>
	{+END}
{+END}
