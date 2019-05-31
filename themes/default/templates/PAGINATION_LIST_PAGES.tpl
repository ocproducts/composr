<form title="{!COUNT_PAGES}" class="inline" action="{$URL_FOR_GET_FORM*,{URL}}" method="get">
	{$SET,RAND_PAGINATION_LIST_PAGES,{$RAND}}

	<span class="pagination-pages">
		{HIDDEN}
		<span class="accessibility-hidden"><label for="blp-start{$GET*,RAND_PAGINATION_LIST_PAGES}">{!COUNT_PAGES}{+START,IF_NON_EMPTY,{$GET,TEXT_ID}}: {$GET*,TEXT_ID}{+END}</label></span>
		<select data-change-submit-form="1" id="blp-start{$GET*,RAND_PAGINATION_LIST_PAGES}" name="{START_NAME*}" class="form-control form-control-sm">
			{LIST}
		</select>
	</span>
</form>
