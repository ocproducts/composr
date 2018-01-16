{$REQUIRE_JAVASCRIPT,core_rich_media}
{$REQUIRE_JAVASCRIPT,news}

{$SET,bottom_news_id,{$RAND}}

<div data-tpl="blockBottomNews" data-tpl-params="{+START,PARAMS_JSON,bottom_news_id,news_ticker_text}{_*}{+END}">
	{+START,SET,news_ticker_text}
		<ol class="horizontal-ticker">
			{+START,LOOP,POSTS}
				<li><a title="{$STRIP_TAGS,{NEWS_TITLE}}: {DATE*}" class="nvn" href="{FULL_URL*}">{NEWS_TITLE}</a></li>
			{+END}
		</ol>
	{+END}

	<div class="ticker-wrap" role="marquee" id="ticktickticker_news{$GET%,bottom_news_id}"></div>
</div>
