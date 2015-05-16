<form title="{!COUNT_PAGES}" class="inline" action="{$URL_FOR_GET_FORM*,{URL}}" method="get" target="_self">
	{$SET,RAND,{$RAND}}

	<div class="pagination_pages">
		{HIDDEN}
		<div class="accessibility_hidden"><label for="blp_start{$GET*,RAND}">{!COUNT_PAGES}: {$GET*,TEXT_ID}</label></div>
		<select{+START,IF,{$JS_ON}} onchange="/*guarded*/this.form.submit();"{+END} id="blp_start{$GET*,RAND}" name="{START_NAME*}">
			{LIST}
		</select>{+START,IF,{$NOT,{$JS_ON}}}<input onclick="disable_button_just_clicked(this);" class="buttons__morepage button_micro" type="submit" value="{!JUMP}: {$GET*,TEXT_ID}" />{+END}
	</div>
</form>

