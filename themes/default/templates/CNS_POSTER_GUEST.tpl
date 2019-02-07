{+START,IF,{$EQ,{POSTER_USERNAME},{!SYSTEM}}}
	<em>{$SITE_NAME*}</em>
{+END}
{+START,IF,{$NEQ,{POSTER_USERNAME},{!SYSTEM}}}
	{+START,IF_EMPTY,{LOOKUP_IP_URL}}
		<a class="cns-guest-poster non-link" href="#!" data-cms-tooltip="{ contents: '{POSTER_DETAILS;^*}', triggers: 'hover focus', delay: 0 }">{POSTER_USERNAME*}</a>
	{+END}
	{+START,IF_NON_EMPTY,{LOOKUP_IP_URL}}
		<a class="cns-guest-poster" href="{LOOKUP_IP_URL*}" data-cms-tooltip="{ contents: '{POSTER_DETAILS;^*}', triggers: 'hover focus', delay: 0 }">{POSTER_USERNAME*}</a>
	{+END}
{+END}
