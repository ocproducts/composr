{$,Semantics to show results}
<meta itemprop="ratingCount" content="{$PREG_REPLACE*,[^\d],,{NUM_RATINGS}}" />
<meta itemprop="ratingValue" content="{RATING*}" />

{$,Shows only if no rating form [which build in result display] or if likes enabled [shows separate stars results and form]}
{+START,IF,{$OR,{LIKES},{$IS_EMPTY,{$TRIM,{RATING_FORM}}}}}
	{+START,IF_NON_EMPTY,{TITLE}}
		<strong>{TITLE*}:</strong>
	{+END}

	{$,Visually show results}
	{$SET,rating_loop,0}
	{+START,SET,rating_stars}{$ROUND,{$DIV_FLOAT,{RATING},2}}{+END}
	{+START,WHILE,{$LT,{$GET,rating_loop},{$GET,rating_stars}}}<img src="{$IMG*,icons/14x14/rating}" srcset="{$IMG*,icons/28x28/rating} 2x" {$?,{$EQ,{$GET,rating_loop},0},alt="{!HAS_RATING,{$GET,rating_stars}}" title="{!HAS_RATING,{$GET,rating_stars}}",alt=""} />{$INC,rating_loop}{+END}
	{+START,IF_NON_PASSED_OR_FALSE,NO_PEOPLE_SHOWN}{+START,IF,{LIKES}}{+START,IF_PASSED,LIKED_BY}{+START,IF_NON_EMPTY,{LIKED_BY}}
		{$SET,done_one_liker,0}
		{+START,LOOP,LIKED_BY}{+START,IF_NON_EMPTY,{$AVATAR,{MEMBER_ID}}}{+START,IF,{$NOT,{$GET,done_one_liker,0}}}({+END}<a href="{$MEMBER_PROFILE_URL*,{MEMBER_ID}}"><img width="10" height="10" src="{$ENSURE_PROTOCOL_SUITABILITY*,{$AVATAR,{MEMBER_ID}}}" title="{!LIKED_BY} {USERNAME*}" alt="{!LIKED_BY} {$DISPLAYED_USERNAME*,{USERNAME}}" /></a>{$SET,done_one_liker,1}{+END}{+END}{+START,IF,{$GET,done_one_liker,0}}){+END}
	{+END}{+END}{+END}{+END}
{+END}
