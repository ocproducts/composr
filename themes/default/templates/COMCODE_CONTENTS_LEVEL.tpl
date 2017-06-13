<ol style="list-style-type: {$REPLACE*,;,,{TYPE}}" class="comcode_contents_level">
	{+START,LOOP,LINES}
		<li class="comcode_contents_level">
			<a href="{URL*}#title__{ID*}">{$TRUNCATE_LEFT,{LINE},100,1,1}</a>
			{UNDER}
		</li>
	{+END}
</ol>
