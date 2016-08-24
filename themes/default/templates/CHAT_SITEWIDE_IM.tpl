{$SET,matched,0}
{+START,IF,{$NOT,{$MATCH_KEY_MATCH,_WILD:chat:room}}}
{$SET,matched,1}
{+END}

{$SET,lobby_link,{$PAGE_LINK,_SEARCH:chat:browse:enter_im=!!}}

{CHAT_SOUND}

<script type="application/json" data-tpl-chat="chatSitewideIm">
	{+START,PARAMS_JSON,matched,lobby_link,IM_AREA_TEMPLATE,IM_PARTICIPANT_TEMPLATE}{_/}{+END}
</script>