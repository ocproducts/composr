{$REQUIRE_JAVASCRIPT,news}
{+START,IF,{$NOT,{TICKER}}}
	<section id="tray_{TITLE|}" data-toggleable-tray="{ save: true }" class="box box---block-side-rss">
		<h3 class="toggleable-tray-title js-tray-header">
			<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!"><img alt="{!CONTRACT}: {$STRIP_TAGS,{TITLE`}}" title="{!CONTRACT}" width="24" height="24" src="{$IMG*,1x/trays/contract2}" /></a>

			{+START,IF_NON_EMPTY,{TITLE}}
				<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!">{TITLE`}</a>
			{+END}
		</h3>

		<div class="toggleable-tray js-tray-content">
			{+START,IF_EMPTY,{CONTENT}}
				<p class="nothing-here">{!NO_NEWS}</p>
			{+END}
			{+START,IF_NON_EMPTY,{CONTENT}}
				<div class="webstandards-checker-off">
					{CONTENT}
				</div>
			{+END}
		</div>
	</section>
{+END}

{+START,IF,{TICKER}}
	{$SET,side_news_id,{$RAND}}

	<section class="box box---block-side-rss"><div class="box-inner">
		{+START,IF_NON_EMPTY,{TITLE}}<h3>{TITLE`}</h3>{+END}

		{+START,IF_EMPTY,{CONTENT}}
			<p class="nothing-here">{!NO_NEWS}</p>
		{+END}
		{+START,IF_NON_EMPTY,{CONTENT}}
			<div class="webstandards-checker-off wide-ticker" id="news_scroller{$GET%,side_news_id}" data-cms-news-scroller="1">
				{CONTENT}
			</div>
		{+END}
	</div></section>
{+END}
