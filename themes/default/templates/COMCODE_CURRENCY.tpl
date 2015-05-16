{+START,IF,{$NOT,{BRACKET}}}
	{$CURRENCY,{AMOUNT},{FROM_CURRENCY},,1}
{+END}
{+START,IF,{BRACKET}}
	{$CURRENCY_SYMBOL,{FROM_CURRENCY}}{AMOUNT*}{+START,IF_EMPTY,{$CURRENCY_SYMBOL,{FROM_CURRENCY}}}&nbsp;{FROM_CURRENCY*}{+END}&nbsp;({$CURRENCY,{AMOUNT},{FROM_CURRENCY},,1}&nbsp;<a rel="external" title="&dagger; {!LINK_NEW_WINDOW}" target="_blank" href="http://www.x-rates.com/cgi-bin/cgicalc.cgi?value={AMOUNT*}&amp;base={FROM_CURRENCY*}">&dagger;</a>)
{+END}

