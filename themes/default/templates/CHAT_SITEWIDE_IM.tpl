{$SET,matched,{$NOT,{$MATCH_KEY_MATCH,_WILD:chat:room}}}
{$SET,lobby_link,{$PAGE_LINK,_SEARCH:chat:browse:enter_im=!!}}
<div data-tpl="chatSitewideIm" data-tpl-args="{+START,PARAMS_JSON,matched,lobby_link,IM_AREA_TEMPLATE,IM_PARTICIPANT_TEMPLATE}{_*}{+END}">
{CHAT_SOUND}
</div>