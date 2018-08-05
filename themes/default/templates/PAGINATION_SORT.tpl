<form title="{!SORT}" action="{$URL_FOR_GET_FORM*,{URL}}{+START,IF_PASSED,HASH}#{HASH*}{+END}" method="get" data-ajaxify-target="1" class="inline" autocomplete="off">
	{$HIDDENS_FOR_GET_FORM,{URL},{SORT}}

	{$SET,RAND_PAGINATION,{$RAND}}

	<div class="inline">
		{+START,SET,sort_button}
			{+START,IF,{$GET,show_sort_button}}
				{+START,IF_NON_PASSED,FILTER}
					<button data-disable-on-click="1" class="button-micro buttons--sort" type="submit" title="{!SORT}{+START,IF_NON_EMPTY,{$GET,TEXT_ID}}: {$GET*,TEXT_ID}{+END}">{+START,INCLUDE,ICON}NAME=buttons/sort{+END} {!SORT}</button>
				{+END}
			{+END}
			{+START,IF_PASSED,FILTER}
				<button data-disable-on-click="1" class="button-micro buttons--filter" type="submit" title="{!PROCEED}{+START,IF_NON_EMPTY,{$GET,TEXT_ID}}: {$GET*,TEXT_ID}{+END}">{+START,INCLUDE,ICON}NAME=buttons/filter{+END} {!PROCEED}</button>
			{+END}
		{+END}

		{+START,IF_PASSED,HIDDEN}
			{HIDDEN}
		{+END}

		{+START,IF_PASSED,FILTER}
			<label for="filter"><span class="field-name">{!SEARCH}:</span> <input value="{FILTER*}" name="filter" id="filter" size="10" /></label>
		{+END}

		<label for="r-{$GET*,RAND_PAGINATION}">{!SORT_BY} <span class="accessibility-hidden">{$GET*,TEXT_ID}</span></label>
		<select {+START,IF,{$NOT,{$GET,show_sort_button}}} data-change-submit-form=""{+END} id="r-{$GET*,RAND_PAGINATION}" name="{SORT*}">
			{SELECTORS}
		</select>{$GET,sort_button}
	</div>
</form>
