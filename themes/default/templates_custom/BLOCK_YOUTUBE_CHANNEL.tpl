{+START,IF_EMPTY,{CHANNEL_ERROR}}
	<div class="webstandards_checker_off">
		{CONTENT`}
	</div>
{+END}
{+START,IF_NON_EMPTY,{CHANNEL_ERROR}}
	<div class="webstandards_checker_off">
		<b>Channel Name:</b> <a href='{CHANNEL_URL}' target='_blank'>{CHANNEL_NAME}</a> <br>
		<b>Error:</b> {CHANNEL_ERROR} <br>
	</div>
{+END}
