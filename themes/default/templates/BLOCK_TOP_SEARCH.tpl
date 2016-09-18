<form role="search" title="{TITLE*}" onsubmit="if (typeof this.elements['content']=='undefined') { disable_button_just_clicked(this); return true; } if (check_field_for_blankness(this.elements['content'],event)) { disable_button_just_clicked(this); return true; } return false;" action="{$URL_FOR_GET_FORM*,{URL}}" method="get" autocomplete="off">
	{$HIDDENS_FOR_GET_FORM,{URL}}

	<div class="inline">
		<label class="accessibility_hidden" for="top_search_content">{!SEARCH}</label>
		<input{+START,IF,{$MOBILE}} autocorrect="off"{+END} autocomplete="off" size="{$?,{!takes_lots_of_space},10,20}" maxlength="255" onkeyup="update_ajax_search_list(this,event{+START,IF_PASSED,SEARCH_TYPE},'{SEARCH_TYPE;^*}'{+END});" type="search" id="top_search_content" name="content" value="" /><input class="button_micro buttons__search" type="submit" value="{!SEARCH}" />

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
	</div>
</form>
