<form title="{!PER_PAGE}" action="{$URL_FOR_GET_FORM*,{URL}}{+START,IF_PASSED,HASH}#{HASH*}{+END}" method="get" class="inline">
	{$SET,RAND_PAGINATION_PER_PAGE,{$RAND}}

	{HIDDEN}
	<span class="inline">
		<span class="accessibility-hidden"><label for="r-{$GET*,RAND_PAGINATION_PER_PAGE}">{!PER_PAGE}{+START,IF_NON_EMPTY,{$GET,TEXT_ID}}: {$GET*,TEXT_ID}{+END}</label></span>
		<select id="r-{$GET*,RAND_PAGINATION_PER_PAGE}" name="{MAX_NAME*}" class="form-control form-control-sm">
			{SELECTORS}
		</select>
		<button data-disable-on-click="1" class="btn btn-primary btn-sm buttons--filter" type="submit" title="{!PER_PAGE}{+START,IF_NON_EMPTY,{$GET,TEXT_ID}}: {$GET*,TEXT_ID}{+END}">{+START,INCLUDE,ICON}NAME=buttons/filter{+END} {!PER_PAGE}</button>
	</span>
</form>
