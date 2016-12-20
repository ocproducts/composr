{+START,IF,{$TAPATALK}}
	<blockquote>
		<h4>{+START,IF,{SAIDLESS}}{BY*}{+END}{+START,IF,{$NOT,{SAIDLESS}}}{!SAID,{BY*}}{+END}</h4>

		{$PREG_REPLACE,<blockquote.*>.*</blockquote>,,{CONTENT},s}
	</blockquote>
{+END}

{+START,IF,{$NOT,{$TAPATALK}}}
	<blockquote class="comcode_quote"{+START,IF_PASSED,CITE} cite="{CITE*}"{+END}>
		<h4>{+START,IF,{SAIDLESS}}{BY*}{+END}{+START,IF,{$NOT,{SAIDLESS}}}{!SAID,{BY*}}{+END}</h4>

		<div class="comcode_quote_inner comcode_quote_inner_titled">
			{+START,IF,{$MOBILE}}
				{$PREG_REPLACE,<blockquote.*>.*</blockquote>,,{CONTENT},s}
			{+END}
			{+START,IF,{$NOT,{$MOBILE}}}
				{CONTENT}
			{+END}
		</div>
	</blockquote>
{+END}
