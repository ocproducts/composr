<form title="{!SORT}" action="{$URL_FOR_GET_FORM*,{URL}}{+START,IF_PASSED,HASH}#{HASH*}{+END}" method="get" target="_self" class="inline" autocomplete="off">
	{$HIDDENS_FOR_GET_FORM,{URL},{SORT}}

	{$SET,RAND_PAGINATION,{$RAND}}

	<div class="inline">
		{+START,SET,sort_button}
			{+START,IF,{$OR,{$GET,show_sort_button},{$NOT,{$JS_ON}}}}
				{+START,IF_NON_PASSED,FILTER}
					<input onclick="disable_button_just_clicked(this);" class="button_micro buttons__sort" type="submit" title="{!SORT}{+START,IF_NON_EMPTY,{$GET,TEXT_ID}}: {$GET*,TEXT_ID}{+END}" value="{!SORT}" />
				{+END}
			{+END}
			{+START,IF_PASSED,FILTER}
				<input onclick="disable_button_just_clicked(this);" class="button_micro buttons__filter" type="submit" title="{!PROCEED}{+START,IF_NON_EMPTY,{$GET,TEXT_ID}}: {$GET*,TEXT_ID}{+END}" value="{!PROCEED}" />
			{+END}
		{+END}

		{+START,IF_PASSED,HIDDEN}
			{HIDDEN}
		{+END}

		{+START,IF_PASSED,FILTER}
			<label for="filter"><span class="field_name">{!SEARCH}:</span> <input value="{FILTER*}" name="filter" id="filter" size="10" /></label>
		{+END}

		<label for="r_{$GET*,RAND_PAGINATION}">{!SORT_BY} <span class="accessibility_hidden">{$GET*,TEXT_ID}</span></label>
		<select{+START,IF,{$NOR,{$GET,show_sort_button},{$NOT,{$JS_ON}}}} onchange="/*guarded*/this.form.submit();"{+END} id="r_{$GET*,RAND_PAGINATION}" name="{SORT*}">
			{SELECTORS}
		</select>{$GET,sort_button}
	</div>
</form>
