{$REQUIRE_JAVASCRIPT,core_feedback_features}
{$,If may rate}
{+START,IF_EMPTY,{ERROR}}
<div data-tpl="ratingForm" data-tpl-params="{+START,PARAMS_JSON,ERROR,ALL_RATING_CRITERIA}{_*}{+END}">
	{$REQUIRE_JAVASCRIPT,ajax}

	{+START,LOOP,ALL_RATING_CRITERIA}
		{$SET,identifier,{CONTENT_TYPE*}__{TYPE*}__{ID*}}

		<div class="rating_outer">
			<div class="rating_type_title">
				<a id="rating__{$GET,identifier}_jump" rel="dorating"></a>

				{+START,IF_NON_EMPTY,{TITLE}}<strong>{TITLE*}:</strong>{+END}
			</div>

			<div class="rating_inner">
				{$,Like/dislike}
				{+START,IF,{LIKES}}
					<img id="rating_bar_1__{$GET,identifier}" alt="" src="{$IMG*,1x/dislike}" srcset="{$IMG*,2x/dislike} 2x" /><img id="rating_bar_10__{$GET,identifier}" alt="" src="{$IMG*,1x/like}" srcset="{$IMG*,2x/like} 2x" />
				{+END}

				{$,Star ratings}
				{+START,IF,{$NOT,{LIKES}}}
					<img id="rating_bar_2__{$GET,identifier}" alt="" src="{$IMG*,icons/14x14/rating}" srcset="{$IMG*,icons/28x28/rating} 2x" /><img id="rating_bar_4__{$GET,identifier}" alt="" src="{$IMG*,icons/14x14/rating}" srcset="{$IMG*,icons/28x28/rating} 2x" /><img id="rating_bar_6__{$GET,identifier}" alt="" src="{$IMG*,icons/14x14/rating}" srcset="{$IMG*,icons/28x28/rating} 2x" /><img id="rating_bar_8__{$GET,identifier}" alt="" src="{$IMG*,icons/14x14/rating}" srcset="{$IMG*,icons/28x28/rating} 2x" /><img id="rating_bar_10__{$GET,identifier}" alt="" src="{$IMG*,icons/14x14/rating}" srcset="{$IMG*,icons/28x28/rating} 2x" />
				{+END}
			</div>
		</div>
	{+END}
</div>
{+END}
