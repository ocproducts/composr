{+START,IF,{$OR,{HAS_RATINGS},{$IS_NON_EMPTY,{$TRIM,{RATING_FORM}}}}}
	<div class="RATING_INLINE RATING_INLINE_DYNAMIC" itemscope="itemscope" itemtype="http://schema.org/AggregateRating">
		{$,Show the current result (nothing shows if nobody voted yet; by default RATING_DISPLAY_SHARED nothing shows if RATING_FORM is not blank either, as the rating stars will show the current rating too)}
		{+START,IF,{HAS_RATINGS}}
			{$SET,i,0}
			{+START,LOOP,ALL_RATING_CRITERIA}
				<div{+START,IF,{$NEQ,{$GET,i},0}} class="horiz_field_sep"{+END}>
					{+START,INCLUDE,RATING_DISPLAY_SHARED}{+END}
				</div>
				{$INC,i}
			{+END}
		{+END}

		{$,Allow rating}
		{$SET,block_embedded_forms,1}
		{+START,IF_NON_EMPTY,{$TRIM,{RATING_FORM}}}
			<div{+START,IF,{$AND,{HAS_RATINGS},{LIKES},{$IS_NON_EMPTY,{ALL_RATING_CRITERIA}}}} class="horiz_field_sep"{+END}>
				{RATING_FORM}
			</div>
		{+END}
		{$SET,block_embedded_forms,0}
	</div>
{+END}
