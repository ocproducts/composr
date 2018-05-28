<th {+START,IF,{SORT_ASC_SELECTED}} aria-sort="ascending"{+END}{+START,IF,{SORT_DESC_SELECTED}} aria-sort="descending"{+END} class="table-header-sorted">
	{VALUE*}

	<span class="table-header-sorting">
		<a rel="nofollow" target="_self" title="{!SORT_BY} {!ALPHABETICAL_FORWARD}{+START,IF_NON_EMPTY,{$GET,TEXT_ID}}: {$GET*,TEXT_ID}{+END}" href="{SORT_URL_ASC*}" class="table-header-sorting-link {$?,{SORT_ASC_SELECTED},selected}">
			{+START,INCLUDE,ICON}
				NAME=results/sortablefield_asc
				ICON_SIZE=12
			{+END}
		</a>
		<a rel="nofollow" target="_self" title="{!SORT_BY} {!ALPHABETICAL_BACKWARD}{+START,IF_NON_EMPTY,{$GET,TEXT_ID}}: {$GET*,TEXT_ID}{+END}" href="{SORT_URL_DESC*}" class="table-header-sorting-link {$?,{SORT_DESC_SELECTED},selected}">
			{+START,INCLUDE,ICON}
				NAME=results/sortablefield_desc
				ICON_SIZE=12
			{+END}
		</a>
	</span>
</th>
