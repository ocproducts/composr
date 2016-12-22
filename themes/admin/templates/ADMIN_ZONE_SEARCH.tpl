{$REQUIRE_JAVASCRIPT,admin_core}
{+START,IF,{$HAS_ACTUAL_PAGE_ACCESS,admin,adminzone}}
	<div class="adminzone_search" data-tpl="adminZoneSearch">
		<form title="{!SEARCH}" action="{$URL_FOR_GET_FORM*,{$PAGE_LINK,adminzone:admin:search}}" method="get" class="inline" autocomplete="off">
			<div id="adminzone_search_hidden" class="js-adminzone-search-hiddens">
				{$HIDDENS_FOR_GET_FORM,{$PAGE_LINK,adminzone:admin:search}}
			</div>

			<div>
				<label for="search_content" class="accessibility_hidden">{!SEARCH}</label>
				<input size="25" type="search" id="search_content" name="content" placeholder="{!SEARCH*}" value="" />
				<div class="accessibility_hidden"><label for="new_window">{!NEW_WINDOW}</label></div>
				<input title="{!NEW_WINDOW}" type="checkbox" value="1" id="new_window" name="new_window" />
				<input type="submit" value="{$?,{$MOBILE},{!SEARCH},{!SEARCH_ADMIN}}" class="button_screen_item buttons__search js-click-btn-admin-search" data-tp-hiddens="{$HIDDENS_FOR_GET_FOR*,{$PAGE_LINK,adminzone:admin:search}}" data-tp-action-url="{$URL_FOR_GET_FORM*,{$PAGE_LINK,adminzone:admin:search}}" />
				{+START,IF,{$NOT,{$MOBILE}}}
					<input type="submit" value="{!SEARCH_TUTORIALS}" class="button_screen_item buttons__menu__pages__help js-click-btn-admin-search-tutorials" data-tp-hiddens="{$HIDDENS_FOR_GET_FORM*,{$BRAND_BASE_URL}/index.php?page=search&type=results}" data-tp-action-url="{$URL_FOR_GET_FORM*,{$BRAND_BASE_URL}/index.php?page=search&type=results}" />
				{+END}
			</div>
		</form>
	</div>
{+END}
