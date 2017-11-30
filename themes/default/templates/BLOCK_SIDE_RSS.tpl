{$REQUIRE_JAVASCRIPT,news}
{+START,IF,{$NOT,{TICKER}}}
	<section id="tray_{TITLE|}" data-toggleable-tray="{ save: true }" class="box box___block_side_rss">
		<h3 class="toggleable_tray_title js-tray-header">
			<a class="toggleable_tray_button js-tray-onclick-toggle-tray" href="#!"><img alt="{!CONTRACT}: {$STRIP_TAGS,{TITLE`}}" title="{!CONTRACT}" src="{$IMG*,1x/trays/contract2}" /></a>

			{+START,IF_NON_EMPTY,{TITLE}}
				<a class="toggleable_tray_button js-tray-onclick-toggle-tray" href="#!">{TITLE`}</a>
			{+END}
		</h3>

		<div class="toggleable_tray js-tray-content">
			{+START,IF_EMPTY,{CONTENT}}
				<p class="nothing_here">{!NO_NEWS}</p>
			{+END}
			{+START,IF_NON_EMPTY,{CONTENT}}
				<div class="webstandards_checker_off">
					{CONTENT}
				</div>
			{+END}
		</div>
	</section>
{+END}

{+START,IF,{TICKER}}
	{$SET,side_news_id,{$RAND}}

	<section class="box box___block_side_rss"><div class="box_inner">
		{+START,IF_NON_EMPTY,{TITLE}}<h3>{TITLE`}</h3>{+END}

		{+START,IF_EMPTY,{CONTENT}}
			<p class="nothing_here">{!NO_NEWS}</p>
		{+END}
		{+START,IF_NON_EMPTY,{CONTENT}}
			<div class="webstandards_checker_off wide_ticker" id="news_scroller{$GET%,side_news_id}" data-cms-news-scroller="1">
				{CONTENT}
			</div>
		{+END}
	</div></section>
{+END}
