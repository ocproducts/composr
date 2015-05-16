<th{+START,IF,{SORT_ASC_SELECTED}} aria-sort="ascending"{+END}{+START,IF,{SORT_DESC_SELECTED}} aria-sort="descending"{+END}>
	{VALUE*}

	<span class="table_header_sorting">
		<a rel="nofollow" target="_self" title="{!SORT_BY}, {!ALPHABETICAL_FORWARD}: {$GET*,TEXT_ID}" href="{SORT_URL_ASC*}"><img src="{$IMG*,results/{$?,{SORT_ASC_SELECTED},sortablefield_asc,sortablefield_asc_nonselected}}" alt="{!SORT_BY}, {!SMALLEST_FIRST}" /></a>
		<a rel="nofollow" target="_self" title="{!SORT_BY}, {!ALPHABETICAL_BACKWARD}: {$GET*,TEXT_ID}" href="{SORT_URL_DESC*}"><img src="{$IMG*,results/{$?,{SORT_DESC_SELECTED},sortablefield_desc,sortablefield_desc_nonselected}}" alt="{!SORT_BY}, {!LARGEST_FIRST}" /></a>
	</span>
</th>
