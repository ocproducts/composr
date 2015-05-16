<div class="left">
	{+START,IF,{HAS_RATINGS}}
		{+START,LOOP,ALL_RATING_CRITERIA}
			{+START,IF_NON_EMPTY,{TITLE}}
				<strong>{TITLE*}:</strong>
			{+END}
			{$SET,rating_loop,0}
			{+START,WHILE,{$LT,{$GET,rating_loop},{$ROUND,{$DIV_FLOAT,{RATING},2}}}}
				<img src="{$IMG*,icons/14x14/rating}" srcset="{$IMG*,icons/28x28/rating} 2x" alt="{$ROUND,{$DIV_FLOAT,{RATING},2}}" />
				{$INC,rating_loop}
			{+END}
		{+END}
	{+END}
	{+START,IF,{$NOT,{HAS_RATINGS}}}
		<em>{!UNRATED}</em>
	{+END}

	<span class="associated_details"><em>{!VOTES,{OVERALL_NUM_RATINGS*}}</em></span>
	<span class="wiki_rating_inside">{RATING_FORM}</span>
</div>

