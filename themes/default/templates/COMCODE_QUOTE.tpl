{+START,IF,{$TAPATALK}}
	<blockquote>
		{$PREG_REPLACE,<blockquote.*>.*</blockquote>,,{CONTENT},s}
	</blockquote>
{+END}

{+START,IF,{$NOT,{$TAPATALK}}}
	<blockquote class="comcode_quote"{+START,IF_PASSED,CITE} cite="{CITE*}"{+END}>
		<div class="comcode_quote_inner">
			<div class="float_surrounder">
				{+START,IF,{$MOBILE}}
					{$PREG_REPLACE,<blockquote.*>.*</blockquote>,,{CONTENT},s}
				{+END}
				{+START,IF,{$NOT,{$MOBILE}}}
					{CONTENT}
				{+END}
			</div>
		</div>
	</blockquote>
{+END}
