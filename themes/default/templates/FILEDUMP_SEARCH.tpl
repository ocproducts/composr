<div class="float_surrounder">
	{+START,IF,{$ADDON_INSTALLED,search}}
		{$SET,search_url,{$SELF_URL}}
		<form class="filedump_filter" role="search" title="{!SEARCH}" onsubmit="disable_button_just_clicked(this); action.href+=window.location.hash; if (this.elements['search'].value=='{!SEARCH;*}') this.elements['search'].value='';" action="{$URL_FOR_GET_FORM*,{$GET,search_url},search,type_filter,sort,place,recurse}" method="get" autocomplete="off">
			{$HIDDENS_FOR_GET_FORM,{$GET,search_url},search,type_filter,sort,place,recurse}

			<p class="left">
				<label class="accessibility_hidden" for="search_filedump_{I*}">{!SEARCH}</label>
				<input{+START,IF,{$MOBILE}} autocorrect="off"{+END} autocomplete="off" maxlength="255" size="22" type="search" id="search_filedump_{I*}" name="search" onfocus="placeholder_focus(this,'{!SEARCH;}');" onblur="placeholder_blur(this,'{!SEARCH;}');" class="{$?,{$IS_EMPTY,{SEARCH}},field_input_non_filled,field_input_filled}" value="{$?,{$IS_EMPTY,{SEARCH}},{!SEARCH},{SEARCH}}" />

				<label for="recurse_{I*}">{!INCLUDE_SUBFOLDERS}</label>
				<input{+START,IF,{$NEQ,{$_GET,recurse},0}} checked="checked"{+END} type="checkbox" name="recurse" id="recurse_{I*}" value="1" />

				<label class="horiz_field_sep" for="type_filter_filedump_{I*}">{!SHOW}</label>
				<select id="type_filter_filedump_{I*}" name="type_filter">
					<option{+START,IF,{$EQ,{TYPE_FILTER},}} selected="selected"{+END} value="">{!ALL}</option>
					<option{+START,IF,{$EQ,{TYPE_FILTER},images}} selected="selected"{+END} value="images">{!IMAGES}</option>
					<option{+START,IF,{$EQ,{TYPE_FILTER},videos}} selected="selected"{+END} value="videos">{!VIDEOS}</option>
					<option{+START,IF,{$EQ,{TYPE_FILTER},audios}} selected="selected"{+END} value="audios">{!AUDIOS}</option>
					<option{+START,IF,{$EQ,{TYPE_FILTER},others}} selected="selected"{+END} value="others">{!OTHER}</option>
				</select>

				<label class="horiz_field_sep" for="jump_to_{I*}">{!JUMP_TO_FOLDER}</label>
				<select id="jump_to_{I*}" name="place">
					{+START,IF_NON_EMPTY,{FILTERED_DIRECTORIES_MISSES}}
						<optgroup label="{!FILEDUMP_FOLDER_MATCHING}">
					{+END}
					{+START,LOOP,FILTERED_DIRECTORIES}
						<option{+START,IF,{$EQ,{$_GET,place,/},/{_loop_var*}{$?,{$IS_NON_EMPTY,{_loop_var}},/}}} selected="selected"{+END} value="/{_loop_var*}{$?,{$IS_NON_EMPTY,{_loop_var}},/}">/{_loop_var*}</option>
					{+END}
					{+START,IF_NON_EMPTY,{FILTERED_DIRECTORIES_MISSES}}
						</optgroup>
					{+END}
					{+START,IF_NON_EMPTY,{FILTERED_DIRECTORIES_MISSES}}
						<optgroup label="{!FILEDUMP_FOLDER_NON_MATCHING}">
							{+START,LOOP,FILTERED_DIRECTORIES_MISSES}
								<option{+START,IF,{$EQ,{$_GET,place,/},/{_loop_var*}{$?,{$IS_NON_EMPTY,{_loop_var}},/}}} selected="selected"{+END} value="/{_loop_var*}{$?,{$IS_NON_EMPTY,{_loop_var}},/}">/{_loop_var*}</option>
							{+END}
						</optgroup>
					{+END}
				</select>

				<label class="horiz_field_sep" for="sort_filedump_{I*}">{!SORT_BY}</label>
				<select id="sort_filedump_{I*}" name="sort">
					<option{+START,IF,{$EQ,{SORT},time ASC}} selected="selected"{+END} value="time ASC">{!DATE_TIME},{!_ASCENDING}</option>
					<option{+START,IF,{$EQ,{SORT},time DESC}} selected="selected"{+END} value="time DESC">{!DATE_TIME},{!_DESCENDING}</option>
					<option{+START,IF,{$EQ,{SORT},name ASC}} selected="selected"{+END} value="name ASC">{!FILENAME},{!_ASCENDING}</option>
					<option{+START,IF,{$EQ,{SORT},name DESC}} selected="selected"{+END} value="name DESC">{!FILENAME},{!_DESCENDING}</option>
					<option{+START,IF,{$EQ,{SORT},size ASC}} selected="selected"{+END} value="size ASC">{!FILE_SIZE},{!_ASCENDING}</option>
					<option{+START,IF,{$EQ,{SORT},size DESC}} selected="selected"{+END} value="size DESC">{!FILE_SIZE},{!_DESCENDING}</option>
				</select>

				<input class="button_micro buttons__filter" type="submit" value="{!FILTER}" />
			</p>
		</form>
	{+END}
</div>
