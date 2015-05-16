{+START,IF,{SYSTEM_MESSAGE}}
	<p>{MESSAGE}</p>
{+END}
{+START,IF,{$NOT,{SYSTEM_MESSAGE}}}
	<div class="box box___chat_private"><div class="box_inner">
		<div><span class="chat_message_by">{MEMBER*}</span></div>
		<p class="chat_private_message">{MESSAGE}</p>
	</div></div>
{+END}
