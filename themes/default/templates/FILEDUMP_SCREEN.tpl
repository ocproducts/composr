{TITLE}

{+START,SET_NOPREEVAL,file_dump_search}
	<div class="float_surrounder">
		{+START,IF,{$ADDON_INSTALLED,search}}
			{$SET,search_url,{$SELF_URL}}
			<form class="filedump_filter" role="search" title="{!SEARCH}" onsubmit="disable_button_just_clicked(this); action.href+=window.location.hash; if (this.elements['search'].value=='{!SEARCH;*}') this.elements['search'].value='';" action="{$URL_FOR_GET_FORM*,{$GET,search_url},search,type_filter,sort,place,recurse}" method="get">
				{$HIDDENS_FOR_GET_FORM,{$GET,search_url},search,type_filter,sort,place,recurse}

				<p class="left">
					<label class="accessibility_hidden" for="search_filedump_{$GET*,i}">{!SEARCH}</label>
					<input{+START,IF,{$MOBILE}} autocorrect="off"{+END} autocomplete="off" maxlength="255" size="25" type="search" id="search_filedump_{$GET*,i}" name="search" onfocus="placeholder_focus(this,'{!SEARCH;}');" onblur="placeholder_blur(this,'{!SEARCH;}');" class="{$?,{$IS_EMPTY,{SEARCH}},field_input_non_filled,field_input_filled}" value="{$?,{$IS_EMPTY,{SEARCH}},{!SEARCH},{SEARCH}}" />

					<label for="recurse_{$GET*,i}">{!INCLUDE_SUBFOLDERS}</label>
					<input{+START,IF,{$NEQ,{$_GET,recurse},0}} checked="checked"{+END} type="checkbox" name="recurse" id="recurse_{$GET*,i}" value="1" />

					<label class="horiz_field_sep" for="type_filter_filedump_{$GET*,i}">{!SHOW}</label>
					<select id="type_filter_filedump_{$GET*,i}" name="type_filter">
						<option{+START,IF,{$EQ,{TYPE_FILTER},}} selected="selected"{+END} value="">{!ALL}</option>
						<option{+START,IF,{$EQ,{TYPE_FILTER},images}} selected="selected"{+END} value="images">{!IMAGES}</option>
						<option{+START,IF,{$EQ,{TYPE_FILTER},videos}} selected="selected"{+END} value="videos">{!VIDEOS}</option>
						<option{+START,IF,{$EQ,{TYPE_FILTER},audios}} selected="selected"{+END} value="audios">{!AUDIOS}</option>
						<option{+START,IF,{$EQ,{TYPE_FILTER},others}} selected="selected"{+END} value="others">{!OTHER}</option>
					</select>

					<label class="horiz_field_sep" for="jump_to_{$GET*,i}">{!JUMP_TO_FOLDER}</label>
					<select id="jump_to_{$GET*,i}" name="place">
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

					<label class="horiz_field_sep" for="sort_filedump_{$GET*,i}">{!SORT_BY}</label>
					<select id="sort_filedump_{$GET*,i}" name="sort">
						<option{+START,IF,{$EQ,{SORT},time ASC}} selected="selected"{+END} value="time ASC">{!DATE_TIME},{!_ASCENDING}</option>
						<option{+START,IF,{$EQ,{SORT},time DESC}} selected="selected"{+END} value="time DESC">{!DATE_TIME},{!_DESCENDING}</option>
						<option{+START,IF,{$EQ,{SORT},name ASC}} selected="selected"{+END} value="name ASC">{!FILENAME},{!_ASCENDING}</option>
						<option{+START,IF,{$EQ,{SORT},name DESC}} selected="selected"{+END} value="name DESC">{!FILENAME},{!_DESCENDING}</option>
						<option{+START,IF,{$EQ,{SORT},size ASC}} selected="selected"{+END} value="size ASC">{!FILE_SIZE},{!_ASCENDING}</option>
						<option{+START,IF,{$EQ,{SORT},size DESC}} selected="selected"{+END} value="size DESC">{!FILE_SIZE},{!_DESCENDING}</option>
					</select>

					<input class="buttons__filter button_micro" type="submit" value="{!FILTER}" />
				</p>
			</form>
		{+END}
	</div>
{+END}

{+START,SET_NOPREEVAL,file_dump_footer}
	<hr class="spaced_rule" />

	<div class="float_surrounder">
		<div class="left">
			<label for="action_{$GET*,i}">{!ACTION}:</label>
			<select id="action_{$GET*,i}" name="action">
				{+START,IF,{$EQ,{$GET,i},1}}
					<option value="">---</option>
				{+END}
				{+START,IF,{$EQ,{$GET,i},2}}
					<option value="edit">{!EDIT_DESCRIPTIONS}</option>
				{+END}
				<option value="delete">{!DELETE_SELECTED}</option>
				{+START,LOOP,OTHER_DIRECTORIES}
					<option value="/{_loop_var*}{+START,IF_NON_EMPTY,{_loop_var}}/{+END}">{!MOVE_TO,/{_loop_var*}}</option>
				{+END}
				<option value="zip">{!FILEDUMP_ZIP}</option>
			</select>

			<input type="submit" value="{!PROCEED}" class="buttons__proceed button_micro" />
		</div>
	</div>
{+END}

<div>
	<div class="float_surrounder"><div class="tabs" role="tablist">
		<a aria-controls="g_thumbnails" role="tab" href="#" id="t_thumbnails" class="tab tab_active tab_first" onclick="event.returnValue=false; select_tab('g','thumbnails'); return false;">{!VIEW_THUMBNAILS}</a>

		<a aria-controls="g_listing" role="tab" href="#" id="t_listing" class="tab{+START,IF_EMPTY,{CREATE_FOLDER_FORM}{UPLOAD_FORM}} tab_last{+END}" onclick="event.returnValue=false; select_tab('g','listing'); return false;">{!VIEW_LISTING}</a>

		{+START,IF_NON_EMPTY,{CREATE_FOLDER_FORM}}
			<a aria-controls="g_create_folder" role="tab" href="#" id="t_create_folder" class="tab{+START,IF_EMPTY,{UPLOAD_FORM}} tab_last{+END}" onclick="event.returnValue=false; select_tab('g','create_folder'); return false;">{!FILEDUMP_CREATE_FOLDER}</a>
		{+END}

		{+START,IF_NON_EMPTY,{UPLOAD_FORM}}
			<a aria-controls="g_upload" role="tab" href="#" id="t_upload" class="tab tab_last" onclick="event.returnValue=false; select_tab('g','upload'); return false;">{!UPLOAD}</a>
		{+END}
	</div></div>
	<div class="tab_surround">
		<div aria-labeledby="t_thumbnails" role="tabpanel" id="g_thumbnails" style="display: block">
			<a id="tab__thumbnails"></a>

			{$SET,i,1}
			{$GET,file_dump_search,1}

			{+START,IF_NON_EMPTY,{$_GET,filename}}
				<script>// <![CDATA[
					add_event_listener_abstract(window,'load',function() {
						faux_open('{$PAGE_LINK;,_SELF:_SELF:embed:place={$_GET&,place}:file={$_GET&,filename}:wide_high=1}',null,'width=950;height=700','_top');
					});
				//]]></script>
			{+END}

			<form title="{!ACTION}" action="{POST_URL*}" method="post" onsubmit="return check_filedump_selections(this);">
				{$INSERT_SPAMMER_BLACKHOLE}

				{+START,IF_NON_EMPTY,{THUMBNAILS}}
					<div class="float_surrounder filedump_thumbnails">
						{+START,LOOP,THUMBNAILS}
							<div class="box"><div class="box_inner">
								{+START,IF,{CHOOSABLE}}
									<span class="filedump_select">{ACTIONS}</span>
								{+END}

								{+START,IF_PASSED,EMBED_URL}
									<p class="filedump_embed"><a id="embed_link_{FILENAME|*}" href="{EMBED_URL*}" onclick="return open_link_as_overlay(this,950,680);" class="link_exempt">{!_FILEDUMP_EMBED}</a></p>
								{+END}

								<p><a{+START,IF,{IS_IMAGE}} rel="lightbox"{+END} href="{URL*}">{THUMBNAIL}</a></p>

								<p class="meta associated_details">
									<strong>{FILENAME*}</strong><br />
									<span class="associated_details">({+START,IF_NON_EMPTY,{_SIZE}}{SIZE*}{+END}{+START,IF_NON_EMPTY,{TIME}}{+START,IF_NON_EMPTY,{_SIZE}}, {+END}{TIME*}{+END}{+START,IF_NON_EMPTY,{WIDTH}}, {WIDTH*}&times;{HEIGHT*}{+END})</span>
								</p>
							</div></div>
						{+END}
					</div>
				{+END}
				{+START,IF_EMPTY,{THUMBNAILS}}
					<p class="nothing_here">{!NO_ENTRIES}</p>
				{+END}

				{$SET,i,1}
				{$GET,file_dump_footer,1}
			</form>

			{+START,INCLUDE,NOTIFICATION_BUTTONS}
				NOTIFICATIONS_TYPE=filedump
				NOTIFICATIONS_ID={PLACE}
				RIGHT=1
			{+END}

			{+START,IF_NON_EMPTY,{PAGINATION_THUMBNAILS}}
				<div class="float_surrounder force_margin">
					{PAGINATION_THUMBNAILS}
				</div>
			{+END}
		</div>

		<div aria-labeledby="t_listing" role="tabpanel" id="g_listing" style="display: {$?,{$JS_ON},none,block}">
			<a id="tab__listing"></a>

			{$SET,i,2}
			{$GET,file_dump_search,1}

			<form title="{!ACTION}" action="{POST_URL*}" method="post" onsubmit="return check_filedump_selections(this);">
				{$INSERT_SPAMMER_BLACKHOLE}

				{+START,IF_NON_EMPTY,{LISTING}}
					{LISTING}
				{+END}
				{+START,IF_EMPTY,{LISTING}}
					<p class="nothing_here">{!NO_ENTRIES}</p>
				{+END}

				{$SET,i,2}
				{$GET,file_dump_footer,1}
			</form>

			{+START,INCLUDE,NOTIFICATION_BUTTONS}
				NOTIFICATIONS_TYPE=filedump
				NOTIFICATIONS_ID={PLACE}
				RIGHT=1
			{+END}

			{+START,IF_NON_EMPTY,{PAGINATION_LISTING}}
				<div class="float_surrounder force_margin">
					{PAGINATION_LISTING}
				</div>
			{+END}
		</div>

		{+START,IF_NON_EMPTY,{CREATE_FOLDER_FORM}}
			<div aria-labeledby="t_create_folder" role="tabpanel" id="g_create_folder" style="display: {$?,{$JS_ON},none,block}">
				<a id="tab__create_folder"></a>

				{+START,INCLUDE,FORM_SCREEN_ARE_REQUIRED}{+END}

				{CREATE_FOLDER_FORM}
			</div>
		{+END}

		{+START,IF_NON_EMPTY,{UPLOAD_FORM}}
			<div aria-labeledby="t_upload" role="tabpanel" id="g_upload" style="display: {$?,{$JS_ON},none,block}">
				<a id="tab__upload"></a>

				{+START,INCLUDE,FORM_SCREEN_ARE_REQUIRED}{+END}

				{UPLOAD_FORM}
			</div>
		{+END}
	</div>
</div>

<script>// <![CDATA[
	add_event_listener_abstract(window,'load',function() {
		find_url_tab();
	});

	function check_filedump_selections(form)
	{
		var action=form.elements['action'].options[form.elements['action'].selectedIndex].value;

		if (action=='')
		{
			fauxmodal_alert('{!SELECT_AN_ACTION;}');
			return false;
		}

		if (action=='edit') return true;

		for (var i=0;i<form.elements.length;i++)
		{
			if ((form.elements[i].name.match(/^select_\d+$/)) && (form.elements[i].checked))
			{
				return true;
			}
		}

		fauxmodal_alert('{!NOTHING_SELECTED_YET;}');
		return false;
	}
//]]></script>

{$,Load up the staff actions template to display staff actions uniformly (we relay our parameters to it)...}
{+START,IF,{$AND,{$SHOW_DOCS},{$HAS_PRIVILEGE,see_software_docs}}}
	{+START,INCLUDE,STAFF_ACTIONS}
		STAFF_ACTIONS_TITLE={!STAFF_ACTIONS}

		1_URL={$TUTORIAL_URL*,tut_collaboration}
		1_TITLE={!HELP}
		1_REL=help
		1_ICON=menu/pages/help

		{+START,IF,{$IS_ADMIN}}
			2_URL={$PAGE_LINK*,_SELF:_SELF:broken}
			2_TITLE={!FIND_BROKEN_FILEDUMP_LINKS}
			2_ICON=menu/adminzone/tools/cleanup
		{+END}
	{+END}
{+END}
