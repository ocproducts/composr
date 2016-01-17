<div class="command float_surrounder">
	{+START,IF_NON_EMPTY,{NOTIFICATIONS}}
		<div>
			{NOTIFICATIONS}
		</div>
	{+END}

	<p class="past_command_prompt">{METHOD*} &rarr;</p>
	<div class="past_command">
		{+START,IF_NON_EMPTY,{STDOUT}}<p class="text_output">{STDOUT*}</p>{+END}
		{STDHTML}
		{+START,IF_NON_EMPTY,{STDCOMMAND}}
			<script>// <![CDATA[
				{STDCOMMAND*/}
			//]]></script>
		{+END}
		{+START,IF_NON_EMPTY,{STDERR}}<p class="red_alert" role="error">{STDERR}</p>{+END}
	</div>
</div>
