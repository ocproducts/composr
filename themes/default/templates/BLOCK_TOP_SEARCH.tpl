{$REQUIRE_JAVASCRIPT,search}

<form role="search" title="{TITLE*}" data-tpl="blockTopSearch" data-tpl-params="{+START,PARAMS_JSON,SEARCH_TYPE}{_*}{+END}" class="js-submit-check-search-content-element" action="{$URL_FOR_GET_FORM*,{URL}}" method="get" autocomplete="off">
	{$HIDDENS_FOR_GET_FORM,{URL}}

	<div class="inline">
		<label class="accessibility-hidden" for="top-search-content-{BLOCK_ID%}">{!SEARCH}</label>
		<input {+START,IF,{$MOBILE}} autocorrect="off"{+END} autocomplete="off" size="{$?,{!takes_lots_of_space},10,20}" maxlength="255" class="js-input-keyup-update-ajax-search-list" type="search" id="top-search-content-{BLOCK_ID%}" name="content" /><button class="button-micro buttons--search" type="submit">{+START,INCLUDE,ICON}NAME=buttons/search{+END} {!SEARCH}</button>

		{+START,LOOP,LIMIT_TO}
			<input type="hidden" name="{_loop_var*}" value="1" />
		{+END}
		{+START,LOOP,EXTRA}
			<input type="hidden" name="{_loop_key*}" value="{_loop_var*}" />
		{+END}
		{+START,IF_NON_EMPTY,{AUTHOR}}<input type="hidden" name="author" value="{AUTHOR*}" />{+END}
		{+START,IF,{$NEQ,{DAYS},-1}}<input type="hidden" name="days" value="{DAYS*}" />{+END}
		{+START,IF,{$NEQ,{SORT},relevance}}<input type="hidden" name="sort" value="{SORT*}" />{+END}
		{+START,IF,{$NEQ,{DIRECTION},DESC}}<input type="hidden" name="direction" value="{DIRECTION*}" />{+END}
		{+START,IF,{$NEQ,{ONLY_TITLES},0}}<input type="hidden" name="only_titles" value="{ONLY_TITLES*}" />{+END}
		{+START,IF,{$NEQ,{ONLY_SEARCH_META},0}}<input type="hidden" name="only_search_meta" value="{ONLY_SEARCH_META*}" />{+END}
		{+START,IF,{$NEQ,{BOOLEAN_SEARCH},0}}<input type="hidden" name="boolean_search" value="{BOOLEAN_SEARCH*}" />{+END}
		{+START,IF,{$NEQ,{CONJUNCTIVE_OPERATOR},AND}}<input type="hidden" name="conjunctive_operator" value="{CONJUNCTIVE_OPERATOR*}" />{+END}
	</div>
</form>
