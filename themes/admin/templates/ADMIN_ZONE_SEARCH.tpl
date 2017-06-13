{+START,IF,{$HAS_ACTUAL_PAGE_ACCESS,admin,adminzone}}
	<div class="adminzone_search">
		<form title="{!SEARCH}" action="{$URL_FOR_GET_FORM*,{$PAGE_LINK,adminzone:admin:search}}" method="get" class="inline" autocomplete="off">
			<div id="adminzone_search_hidden">
				{$HIDDENS_FOR_GET_FORM,{$PAGE_LINK,adminzone:admin:search}}
			</div>

			<div>
				<label for="search_content" class="accessibility_hidden">{!SEARCH}</label>
				<input size="25" type="search" id="search_content" name="content" class="{$?,{$MATCH_KEY_MATCH,adminzone:admin:search},,field_input_non_filled}" onfocus="placeholder_focus(this);/* require_javascript('ajax_people_lists',window.update_ajax_member_list); require_javascript('ajax');*/" onblur="placeholder_blur(this);" onkeyup="/*Annoying and not-helpful if (typeof update_ajax_admin_search_list!='undefined') update_ajax_admin_search_list(this,event);*/" alt="{!SEARCH}" value="{!SEARCH}" />
				{+START,IF,{$JS_ON}}
					<div class="accessibility_hidden"><label for="new_window">{!NEW_WINDOW}</label></div>
					<input title="{!NEW_WINDOW}" type="checkbox" value="1" id="new_window" name="new_window" />
				{+END}
				<input onclick="set_inner_html(document.getElementById('adminzone_search_hidden'), '{$HIDDENS_FOR_GET_FORM;^*,{$PAGE_LINK,adminzone:admin:search}}'); form.action='{$URL_FOR_GET_FORM;*,{$PAGE_LINK,adminzone:admin:search}}'; if ((form.new_window) &amp;&amp; (form.new_window.checked)) form.target='_blank'; else form.target='_top';" class="button_screen_item buttons__search" type="submit" value="{$?,{$MOBILE},{!SEARCH},{!SEARCH_ADMIN}}" />
				{+START,IF,{$AND,{$NOT,{$MOBILE}},{$JS_ON}}}
					<input onclick="set_inner_html(document.getElementById('adminzone_search_hidden'), '{$HIDDENS_FOR_GET_FORM;^*,{$BRAND_BASE_URL*}/index.php?page=search&type=results}'); form.action='{$URL_FOR_GET_FORM;*,{$BRAND_BASE_URL*}/index.php?page=search&amp;type=results}'; form.target='_blank';" class="button_screen_item buttons__menu__pages__help" type="submit" value="{!SEARCH_TUTORIALS}" />
				{+END}
			</div>
		</form>
	</div>
{+END}
