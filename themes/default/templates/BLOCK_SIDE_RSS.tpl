{$REQUIRE_JAVASCRIPT,syndication_blocks}
{+START,IF,{$NOT,{TICKER}}}
	<section id="tray_{TITLE|}" data-view="ToggleableTray" data-tray-cookie="{TITLE|}" class="box box___block_side_rss">
		<h3 class="toggleable_tray_title js-tray-header">
			<a class="toggleable_tray_button js-btn-tray-toggle" href="#!"><img alt="{!CONTRACT}: {$STRIP_TAGS,{TITLE`}}" title="{!CONTRACT}" src="{$IMG*,1x/trays/contract2}" srcset="{$IMG*,2x/trays/contract2} 2x" /></a>

			{+START,IF_NON_EMPTY,{TITLE}}
				<a class="toggleable_tray_button js-btn-tray-toggle" href="#!">{TITLE`}</a>
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
