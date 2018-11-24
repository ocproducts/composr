<form title="{!COUNT_PAGES}" class="inline" action="{$URL_FOR_GET_FORM*,{URL}}" method="get" autocomplete="off">
	{$SET,RAND_PAGINATION_LIST_PAGES,{$RAND}}

	<div class="pagination-pages">
		{HIDDEN}
		<div class="accessibility-hidden"><label for="blp-start{$GET*,RAND_PAGINATION_LIST_PAGES}">{!COUNT_PAGES}{+START,IF_NON_EMPTY,{$GET,TEXT_ID}}: {$GET*,TEXT_ID}{+END}</label></div>
		<select data-change-submit-form="1" id="blp-start{$GET*,RAND_PAGINATION_LIST_PAGES}" name="{START_NAME*}" class="form-control form-control-sm">
			{LIST}
		</select>
	</div>
</form>
