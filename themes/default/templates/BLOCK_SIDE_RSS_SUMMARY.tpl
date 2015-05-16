<div class="box box___block_side_rss_summary"><div class="box_inner">
	{+START,IF,{$NOT,{TICKER}}}
		<p class="tiny_paragraph">
			<a title="{$REPLACE,",&quot;,{$STRIP_TAGS,{NEWS_TITLE}}} {!LINK_NEW_WINDOW}" rel="external" target="_blank" href="{FULL_URL*}">{$TRUNCATE_LEFT,{NEWS_TITLE},30,0,1}</a>
		</p>

		<p class="tiny_paragraph associated_details">
			{DATE*}
		</p>
	{+END}

	{+START,IF,{TICKER}}
		<p>
			<a title="{$REPLACE,",&quot;,{$STRIP_TAGS,{NEWS_TITLE}}} {!LINK_NEW_WINDOW}" rel="external" target="_blank" href="{FULL_URL*}">{NEWS_TITLE}</a>

			<span class="associated_details">({$MAKE_RELATIVE_DATE*,{DATE_RAW}} ago)</span>
		</p>

		{SUMMARY}
	{+END}
</div></div>
