<form title="{!PER_PAGE}" action="{$URL_FOR_GET_FORM*,{URL}}{+START,IF_PASSED,HASH}#{HASH*}{+END}" method="get" class="inline" target="_self">
	{$SET,RAND,{$RAND}}

	{HIDDEN}
	<div class="pagination_per_page">
		<div class="accessibility_hidden"><label for="r_{$GET*,RAND}">{!PER_PAGE}: {$GET*,TEXT_ID}</label></div>
		<select id="r_{$GET*,RAND}" name="{MAX_NAME*}">
			{SELECTORS}
		</select><input onclick="disable_button_just_clicked(this);" class="buttons__filter button_micro" type="submit" title="{!PER_PAGE}: {$GET*,TEXT_ID}" value="{!PER_PAGE}" />
	</div>
</form>
