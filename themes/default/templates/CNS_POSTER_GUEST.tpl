{+START,IF,{$EQ,{POSTER_USERNAME},{!SYSTEM}}}
	<em>{$SITE_NAME*}</em>
{+END}
{+START,IF,{$NEQ,{POSTER_USERNAME},{!SYSTEM}}}
	{+START,IF_EMPTY,{LOOKUP_IP_URL}}
	<a class="cns_guest_poster non_link" href="#!" onblur="this.onmouseout(event);" data-focus-activate-tooltip="['{POSTER_DETAILS;~*}','auto',null,null,null,true]" data-mouseover-activate-tooltip="['{POSTER_DETAILS;~*}','auto',null,null,null,true]">{POSTER_USERNAME*}</a>
	{+END}
	{+START,IF_NON_EMPTY,{LOOKUP_IP_URL}}
	<a class="cns_guest_poster" href="{LOOKUP_IP_URL*}" onblur="this.onmouseout(event);" data-focus-activate-tooltip="['{POSTER_DETAILS;~*}','auto',null,null,null,true]" data-mouseover-activate-tooltip="['{POSTER_DETAILS;~*}','auto',null,null,null,true]">{POSTER_USERNAME*}</a>
	{+END}
{+END}
