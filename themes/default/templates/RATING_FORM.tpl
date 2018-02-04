{$REQUIRE_JAVASCRIPT,core_feedback_features}
{$,If may rate}
{+START,IF_EMPTY,{ERROR}}
	<div data-tpl="ratingForm" data-tpl-params="{+START,PARAMS_JSON,ERROR,ALL_RATING_CRITERIA}{_*}{+END}">
		{+START,LOOP,ALL_RATING_CRITERIA}
			{$SET,identifier,{CONTENT_TYPE*}--{TYPE*}--{ID*}}

			<div class="rating-outer">
				<div class="rating-type-title">
					<a id="rating--{$GET,identifier}-jump" rel="dorating"></a>

					{+START,IF_NON_EMPTY,{TITLE}}<strong>{TITLE*}:</strong>{+END}
				</div>

				<div class="rating-inner">
					{$,Like/dislike}
					{+START,IF,{LIKES}}
						<img id="rating-bar-1--{$GET,identifier}" alt="" width="18" height="18" src="{$IMG*,icons/feedback/dislike}" />
					<img id="rating-bar-10--{$GET,identifier}" alt="" width="18" height="18" src="{$IMG*,icons/feedback/like}" />
					{+END}

					{$,Star ratings}
					{+START,IF,{$NOT,{LIKES}}}
						<img id="rating-bar-2--{$GET,identifier}" alt="" width="14" height="14" src="{$IMG*,icons/feedback/rating}" />
						<img id="rating-bar-4--{$GET,identifier}" alt="" width="14" height="14" src="{$IMG*,icons/feedback/rating}" />
						<img id="rating-bar-6--{$GET,identifier}" alt="" width="14" height="14" src="{$IMG*,icons/feedback/rating}" />
						<img id="rating-bar-8--{$GET,identifier}" alt="" width="14" height="14" src="{$IMG*,icons/feedback/rating}" />
						<img id="rating-bar-10--{$GET,identifier}" alt="" width="14" height="14" src="{$IMG*,icons/feedback/rating}" />
					{+END}
				</div>
			</div>
		{+END}
	</div>
{+END}
