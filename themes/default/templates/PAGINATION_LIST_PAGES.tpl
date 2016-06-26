<form title="{!COUNT_PAGES}" class="inline" action="{$URL_FOR_GET_FORM*,{URL}}" method="get" target="_self" autocomplete="off">
	{$SET,RAND_PAGINATION_LIST_PAGES,{$RAND}}

	<div class="pagination_pages">
		{HIDDEN}
		<div class="accessibility_hidden"><label for="blp_start{$GET*,RAND_PAGINATION_LIST_PAGES}">{!COUNT_PAGES}{+START,IF_NON_EMPTY,{$GET,TEXT_ID}}: {$GET*,TEXT_ID}{+END}</label></div>
		<select{+START,IF,{$JS_ON}} onchange="/*guarded*/this.form.submit();"{+END} id="blp_start{$GET*,RAND_PAGINATION_LIST_PAGES}" name="{START_NAME*}">
			{LIST}
		</select>{+START,IF,{$NOT,{$JS_ON}}}<input onclick="disable_button_just_clicked(this);" class="button_micro buttons__morepage" type="submit" value="{!JUMP}{+START,IF_NON_EMPTY,{$GET,TEXT_ID}}: {$GET*,TEXT_ID}{+END}" />{+END}
	</div>
</form>

