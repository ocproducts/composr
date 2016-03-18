<ol style="list-style-type: {$REPLACE*,;,,{TYPE}}">
	{+START,LOOP,LINES}
		<li>
			<a href="{URL*}#title__{ID*}">{$TRUNCATE_LEFT,{LINE},100,1,1}</a>
			{UNDER}
		</li>
	{+END}
</ol>
