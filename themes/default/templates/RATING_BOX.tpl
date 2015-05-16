<div class="RATING_BOX">
	<section class="box box___rating_box"><div class="box_inner">
		<h3>{!RATING}</h3>

		<div class="rating_inner" itemscope="itemscope" itemtype="http://schema.org/AggregateRating">
			{+START,IF,{HAS_RATINGS}}
				{+START,LOOP,ALL_RATING_CRITERIA}
					{+START,INCLUDE,RATING_DISPLAY_SHARED}{+END}
				{+END}
			{+END}
			{+START,IF,{$NOT,{HAS_RATINGS}}}
				<em>{!UNRATED}</em>
			{+END}

			{+START,IF,{HAS_RATINGS}}
				<span class="horiz_field_sep">{!VOTES,{OVERALL_NUM_RATINGS*}}</span>
			{+END}
		</div>

		{$,We do not show errors for likes as it is too informal to go into details}
		{+START,IF,{$NOT,{LIKES}}}
			{+START,IF_NON_EMPTY,{ERROR}}
				<div class="rating_error">
					{ERROR}
				</div>
			{+END}
		{+END}

		<div class="rating_form">
			{RATING_FORM}
		</div>
	</div></section>
</div>

