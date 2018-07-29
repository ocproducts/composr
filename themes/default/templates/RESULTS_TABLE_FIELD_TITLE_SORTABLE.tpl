<th {+START,IF,{SORT_ASC_SELECTED}} aria-sort="ascending"{+END}{+START,IF,{SORT_DESC_SELECTED}} aria-sort="descending"{+END} class="table-header-sorted{+START,IF_PASSED,SORTABLE_TYPE} table-sortable:{SORTABLE_TYPE*}{+END}{+START,IF_PASSED_AND_TRUE,SEARCHABLE} table-searchable table-searchable-with-substrings{+END}{+START,IF_PASSED_AND_TRUE,FILTERABLE} table-filterable{+END}"{+START,IF_PASSED,COLSPAN} colspan="{COLSPAN*}"{+END}>
	<span>{VALUE*}</span>

	{+START,IF_NON_PASSED_OR_FALSE,INTERACTIVE}
		<span class="table-header-sorting">
			<a rel="nofollow" target="_self" title="{!SORT_BY} {!ALPHABETICAL_FORWARD}{+START,IF_NON_EMPTY,{$GET,TEXT_ID}}: {$GET*,TEXT_ID}{+END}" href="{SORT_URL_ASC*}"><img height="12" src="{$IMG*,results/{$?,{SORT_ASC_SELECTED},sortablefield_asc,sortablefield_asc_nonselected}}" alt="{!SORT_BY} {!ASCENDING}" /></a>
			<a rel="nofollow" target="_self" title="{!SORT_BY} {!ALPHABETICAL_BACKWARD}{+START,IF_NON_EMPTY,{$GET,TEXT_ID}}: {$GET*,TEXT_ID}{+END}" href="{SORT_URL_DESC*}"><img height="12" src="{$IMG*,results/{$?,{SORT_DESC_SELECTED},sortablefield_desc,sortablefield_desc_nonselected}}" alt="{!SORT_BY} {!DESCENDING}" /></a>
		</span>
	{+END}
</th>
