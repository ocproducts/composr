{+START,IF,{$TAPATALK}}
	<blockquote>
		{CONTENT}
	</blockquote>
{+END}

{+START,IF,{$NOT,{$TAPATALK}}}
	<blockquote class="comcode_quote"{+START,IF_PASSED,CITE} cite="{CITE*}"{+END}>
		<div class="comcode_quote_inner">
			<div class="float_surrounder">
				{CONTENT}
			</div>
		</div>
	</blockquote>
{+END}
