{$REQUIRE_JAVASCRIPT,core_rich_media}
<div data-tpl-news="blockBottomNews" data-tpl-args="{+START,PARAMS_JSON,bottom_news_id,news_ticker_text}{_*}{+END}">
{+START,SET,news_ticker_text}
	<ol class="horizontal_ticker">
		{+START,LOOP,POSTS}
			<li><a title="{$STRIP_TAGS,{NEWS_TITLE}}: {DATE*}" class="nvn" href="{FULL_URL*}">{NEWS_TITLE}</a></li>
		{+END}
	</ol>
{+END}

{$SET,bottom_news_id,{$RAND}}

<div class="ticker_wrap" role="marquee" id="ticktickticker_news{$GET%,bottom_news_id}"></div>

<noscript>
	{$GET,news_ticker_text}
</noscript>
</div>