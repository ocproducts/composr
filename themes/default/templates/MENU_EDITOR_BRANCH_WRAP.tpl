{$REQUIRE_JAVASCRIPT,core_menus}

<div class="menu_editor_branch" id="branch_wrap_{I*}" data-tpl="menuEditorBranchWrap" data-tpl-params="{+START,PARAMS_JSON,CLICKABLE_SECTIONS,BRANCH_TYPE,I}{_*}{+END}">
	<div class="menu_editor_branch_inner" id="branch_{I*}">
		<label id="label_caption_{I*}" for="caption_{I*}">{!CAPTION}: </label>
		<input maxlength="255" class="js-focus-make-caption-field-selected js-dblclick-scroll-to-heading"type="text" value="{CAPTION*}" id="caption_{I*}" name="caption_{I*}" />

		<input type="hidden" id="caption_long_{I*}" name="caption_long_{I*}" value="{CAPTION_LONG*}"{+START,IF_EMPTY,{CAPTION_LONG}} disabled="disabled"{+END} />
		<input type="hidden" id="url_{I*}" name="url_{I*}" value="{URL*}" />
		<input type="hidden" id="page_only_{I*}" name="page_only_{I*}" value="{PAGE_ONLY*}"{+START,IF_EMPTY,{PAGE_ONLY}} disabled="disabled"{+END} />
		<input type="hidden" id="theme_img_code_{I*}" name="theme_img_code_{I*}" value="{THEME_IMG_CODE*}"{+START,IF_EMPTY,{THEME_IMG_CODE}} disabled="disabled"{+END} />
		<input type="hidden" id="parent_{I*}" name="parent_{I*}" value="{PARENT*}" />
		<input type="hidden" id="order_{I*}" name="order_{I*}" value="{ORDER*}" />
		<input type="hidden" id="new_window_{I*}" name="new_window_{I*}" value="{NEW_WINDOW*}"{+START,IF,{$NOT,{NEW_WINDOW}}} disabled="disabled"{+END} />
		<input type="hidden" id="check_perms_{I*}" name="check_perms_{I*}" value="{CHECK_PERMS*}"{+START,IF,{$NOT,{CHECK_PERMS}}} disabled="disabled"{+END} />
		<input type="hidden" id="include_sitemap_{I*}" name="include_sitemap_{I*}" value="{INCLUDE_SITEMAP*}"{+START,IF,{$NOT,{INCLUDE_SITEMAP}}} disabled="disabled"{+END} />
		<div class="accessibility_hidden"><label id="label_branch_type_{I*}" for="branch_type_{I*}">{!MENU_ENTRY_BRANCH}</label></div>
		<select style="display: none" class="js-click-menu-editor-branch-type-change js-change-menu-editor-branch-type-change" title="{$STRIP_TAGS,{!MENU_ENTRY_BRANCH}}" id="branch_type_{I*}" name="branch_type_{I*}">
			{+START,IF,{$NOT,{CLICKABLE_SECTIONS}}}
				<option value="page">{!PAGE}</option>
			{+END}
			<option value="branch_minus">{!CONTRACTED_BRANCH}</option>
			<option value="branch_plus">{!EXPANDED_BRANCH}</option>
		</select>

		<input type="image" src="{$IMG*,results/sortablefield_desc}" id="down_{I*}" alt="{!MOVE_DOWN}" data-click-pd="1" class="horiz_field_sep js-click-btn-move-down-handle-ordering">
		<input type="image" src="{$IMG*,results/sortablefield_asc}" id="up_{I*}" alt="{!MOVE_UP}" data-click-pd="1" class="js-click-btn-move-up-handle-ordering">

		<input class="menu___generic_admin__delete button_micro horiz_field_sep js-click-delete-menu-branch" value="{!DELETE}" type="button" id="del_{I*}" name="del_{I*}" />
	</div>

	<div class="menu_editor_branch_indent" id="branch_{I*}_follow_1" style="{DISPLAY*}">
		{BRANCH}
	</div>
	<div class="menu_editor_branch_indent" id="branch_{I*}_follow_2" style="{DISPLAY*}"></div>
</div>
