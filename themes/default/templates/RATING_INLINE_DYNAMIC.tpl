<div class="RATING_INLINE_DYNAMIC" itemscope="itemscope" itemtype="http://schema.org/AggregateRating">
	{$,Show the current result (nothing shows if nobody voted yet)}
	{+START,IF,{HAS_RATINGS}}
		{$SET,i,0}
		{+START,LOOP,ALL_RATING_CRITERIA}
			<div{+START,IF,{$NEQ,{$GET,i},0}} class="horiz_field_sep"{+END}>
				{+START,INCLUDE,RATING_DISPLAY_SHARED}{+END}
			</div>
			{$INC,i}
		{+END}
	{+END}

	{$SET,block_embedded_forms,1}
	{+START,IF_NON_EMPTY,{RATING_FORM}}
		<div{+START,IF,{HAS_RATINGS}} class="horiz_field_sep"{+END}>
			{RATING_FORM}
		</div>
	{+END}
	{$SET,block_embedded_forms,0}
</div>
