{$REQUIRE_JAVASCRIPT,search}

<form class="top-button-wrapper" role="search" title="{TITLE*}" data-tpl="blockTopSearch" data-tpl-params="{+START,PARAMS_JSON,SEARCH_TYPE}{_*}{+END}" action="{$URL_FOR_GET_FORM*,{URL}}" method="get" autocomplete="off">
	<div class="js-clickout-hide-top-search">
		{$HIDDENS_FOR_GET_FORM,{URL}}
		
		{+START,LOOP,LIMIT_TO}
			<input type="hidden" name="{_loop_var*}" value="1" />
		{+END}
		{+START,LOOP,EXTRA}
			<input type="hidden" name="{_loop_key*}" value="{_loop_var*}" />
		{+END}
		<input type="hidden" name="author" value="{AUTHOR*}" />
		<input type="hidden" name="days" value="{DAYS*}" />
		<input type="hidden" name="sort" value="{SORT*}" />
		<input type="hidden" name="direction" value="{DIRECTION*}" />
		<input type="hidden" name="only_titles" value="{ONLY_TITLES*}" />
		<input type="hidden" name="only_search_meta" value="{ONLY_SEARCH_META*}" />
		<input type="hidden" name="boolean_search" value="{BOOLEAN_SEARCH*}" />
		<input type="hidden" name="conjunctive_operator" value="{CONJUNCTIVE_OPERATOR*}" />
	
		<div class="top-button-popup" id="top-search-rel" style="display: none">
			<div class="box box-arrow box--block-top-personal-stats">
				<div class="box-inner">
					<label class="accessibility-hidden" for="top-search-content-{BLOCK_ID%}">{!SEARCH}</label>
					<input {+START,IF,{$MOBILE}} autocorrect="off"{+END} autocomplete="off" size="{$?,{!takes_lots_of_space},10,20}" maxlength="255" class="js-input-keyup-update-ajax-search-list" type="search" id="top-search-content-{BLOCK_ID%}" name="content" />
					<button class="btn btn-primary btn-sm buttons--search" type="submit">{+START,INCLUDE,ICON}NAME=buttons/search{+END} {!SEARCH}</button>
				</div>
			</div>
		</div>
	
		<a id="top-search-button" class="top-button top-button-search js-click-toggle-top-search" href="#!">
			{+START,INCLUDE,ICON}
				NAME=buttons/search
				ICON_SIZE=24
			{+END}
		</a>
	</div>
</form>
