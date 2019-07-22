{$,Read the catalogue tutorial for information on custom catalogue layouts}

<th>
	{$PREG_REPLACE,^.*: ,,{FIELD*}}

	<span class="table-header-sorting">
		{+START,IF,{$NEQ,{$PAGE},search}}
			{+START,IF_NON_EMPTY,{SORT_URL_ASC}}<a target="_self" href="{SORT_URL_ASC*}"><img height="12" src="{$IMG*,results/{$?,{SORT_ASC_SELECTED},sortablefield_asc,sortablefield_asc_nonselected}}" title="{!SORT_BY} {FIELD*}, {!ASCENDING}" alt="{!SORT_BY} {FIELD*}, {!ASCENDING}" /></a>{+END}
		{+END}
		{+START,IF,{$NEQ,{$PAGE},search}}
			{+START,IF_NON_EMPTY,{SORT_URL_DESC}}<a target="_self" href="{SORT_URL_DESC*}"><img height="12" src="{$IMG*,results/{$?,{SORT_DESC_SELECTED},sortablefield_desc,sortablefield_desc_nonselected}}" title="{!SORT_BY} {FIELD*}, {!DESCENDING}" alt="{!SORT_BY} {FIELD*}, {!DESCENDING}" /></a>{+END}
		{+END}
	</span>
</th>
