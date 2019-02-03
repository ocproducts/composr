<div class="rating-box">
	<section class="box box---rating-box"><div class="box-inner">
		<h3>{!RATING}</h3>

		<div class="rating-inner" itemscope="itemscope" itemtype="http://schema.org/AggregateRating">
			{+START,IF,{HAS_RATINGS}}
				{+START,LOOP,ALL_RATING_CRITERIA}
					{+START,INCLUDE,RATING_DISPLAY_SHARED}{+END}
				{+END}
			{+END}
			{+START,IF,{$NOT,{HAS_RATINGS}}}
				<meta itemprop="ratingCount" content="0" />
				<meta itemprop="ratingValue" content="3" />

				<em>{!UNRATED}</em>
			{+END}

			{+START,IF,{HAS_RATINGS}}
				<span class="horiz-field-sep">{!VOTES,{OVERALL_NUM_RATINGS*}}</span>
			{+END}
		</div>

		{$,We do not show errors for likes as it is too informal to go into details}
		{+START,IF,{$NOT,{LIKES}}}{+START,IF_NON_EMPTY,{ERROR}}
			<div class="rating-error">
				{ERROR}
			</div>
		{+END}{+END}

		{+START,IF_NON_EMPTY,{$TRIM,{RATING_FORM}}}
			<div class="rating-form">
				{RATING_FORM}
			</div>
		{+END}
	</div></section>
</div>
