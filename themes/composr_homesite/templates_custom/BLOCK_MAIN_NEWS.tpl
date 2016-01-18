{+START,IF,{$NOT,{$MOBILE}}}
	<div class="ltNews">
		<h4 class="ltNewsHead">
			{TITLE*}
		</h4>

		<div class="ltCnt">
			{CONTENT}
		</div>
	</div>
{+END}

{+START,IF,{$MOBILE}}
	<div class="ltCnt">
		{CONTENT}
	</div>
{+END}
