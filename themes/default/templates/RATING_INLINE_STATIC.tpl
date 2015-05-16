{$,Show the current result (nothing shows if nobody voted yet)}
{+START,IF,{HAS_RATINGS}}
	<div class="RATING_INLINE_STATIC" itemscope="itemscope" itemtype="http://schema.org/AggregateRating">
		{$SET,i,0}
		{+START,LOOP,ALL_RATING_CRITERIA}
			<div{+START,IF,{$NEQ,{$GET,i},0}} class="horiz_field_sep"{+END}>
				{+START,INCLUDE,RATING_DISPLAY_SHARED}
					NO_PEOPLE_SHOWN=1
					RATING_FORM=
				{+END}
			</div>
			{$INC,i}
		{+END}
	</div>
{+END}
