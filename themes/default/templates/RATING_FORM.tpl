{$REQUIRE_JAVASCRIPT,core_feedback_features}
{$,If may rate}
{+START,IF_EMPTY,{ERROR}}
	{+START,IF,{$JS_ON}}
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
	{+END}

	{+START,IF,{$NOT,{$JS_ON}}}
		{+START,IF,{$NOT,{$GET,block_embedded_forms}}}
			<form title="{!RATE}" onsubmit="if (this.elements[0].selectedIndex==0) { window.fauxmodal_alert('{!IMPROPERLY_FILLED_IN=;}'); return false; } else return true;" action="{URL*}" method="post" autocomplete="off">
				{$INSERT_SPAMMER_BLACKHOLE}

				{+START,LOOP,ALL_RATING_CRITERIA}
					{$SET,identifier,{CONTENT_TYPE*}__{TYPE*}__{ID*}}

					<div class="rating_outer">
						<div class="rating_type_title">
							<a id="rating__{$GET,identifier}_jump" rel="dorating"></a>

							{+START,IF_EMPTY,{TITLE}}<div class="accessibility_hidden">{+END}<label{+START,IF_EMPTY,{TYPE}} accesskey="r"{+END} for="rating__{$GET,identifier}"><strong>{+START,IF_EMPTY,{TITLE}}{!RATING}:{+END}{+START,IF_NON_EMPTY,{TITLE}}{TITLE*}:{+END}</strong></label>{+START,IF_EMPTY,{TITLE}}</div>{+END}
						</div>

						<div class="rating_inner">
							<select id="rating__{$GET,identifier}" name="rating__{$GET,identifier}">
								<option value="">&mdash;</option>
								<option value="10">5</option>
								<option value="8">4</option>
								<option value="6">3</option>
								<option value="4">2</option>
								<option value="2">1</option>
							</select>

							{+START,IF,{SIMPLISTIC}}
								<input data-disable-on-click="1" class="button_micro feedback__rate" type="submit" value="{!RATE}" />
							{+END}
						</div>
					</div>
				{+END}
				{+START,IF,{$NOT,{SIMPLISTIC}}}
					<div>
						<input data-disable-on-click="1" class="button_micro feedback__rate" type="submit" value="{!RATE}" />
					</div>
				{+END}
			</form>
		{+END}
	{+END}
{+END}

<script type="application/json" data-tpl-core-feedback-features="ratingForm">
{+START,PARAMS_JSON,ERROR,ALL_RATING_CRITERIA}{_/}{+END}
</script>
