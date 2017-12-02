{$SET,default_zone_page_name,{$DEFAULT_ZONE_PAGE_NAME}}
<div data-view="ZoneEditorScreen" data-view-params="{+START,PARAMS_JSON,default_zone_page_name}{_*}{+END}">
	{TITLE}

	{+START,INCLUDE,HANDLE_CONFLICT_RESOLUTION}{+END}

	{+START,IF_PASSED,WARNING_DETAILS}
		{WARNING_DETAILS}
	{+END}

	<p class="vertical_alignment">
		<img src="{$IMG*,icons/16x16/help}" srcset="{$IMG*,icons/32x32/help} 2x" alt="" /> <span>{!ZE_HOW_TO_SAVE}</span>
	</p>

	<div class="float-surrounder" id="ze_panels_wrap">
		<div id="p_panel_left" class="ze_panel" data-mouseover-class="{ ze_panel_expanded: 1 }" data-mouseout-class="{ ze_panel_expanded: 0 }">
			{LEFT_EDITOR}
		</div>

		<div id="p_panel_right" class="ze_panel" data-mouseover-class="{ ze_panel_expanded: 1 }" data-mouseout-class="{ ze_panel_expanded: 0 }">
			{RIGHT_EDITOR}
		</div>

		<div class="ze_middle">
			{MIDDLE_EDITOR}
		</div>
	</div>

	<hr class="spaced_rule" />

	<form title="{!SAVE}" action="{URL*}" method="post" target="_self" autocomplete="off" class="js-form-ze-save zone_editor_form">
		{$INSERT_SPAMMER_BLACKHOLE}

		<div id="edit_field_store" style="display: none">
		</div>

		<p class="proceed_button vertical_alignment">
			<input class="button_screen buttons__save js-btn-fetch-and-submit" type="button" value="{!SAVE}" /> <span class="associated-details">{!ZE_CLICK_TO_EDIT}</span>
		</p>
	</form>

	<p class="vertical_alignment">
		<img src="{$IMG*,icons/16x16/help}" srcset="{$IMG*,icons/32x32/help} 2x" alt="" /> <span>{!MANY_PANEL_TYPES,{$PAGE_LINK*,cms:cms_comcode_pages:_edit:lang={LANG}:page_link={ID}%3Apanel_top},{$PAGE_LINK*,cms:cms_comcode_pages:_edit:lang={LANG}:page_link={ID}%3Apanel_bottom}}</span>
	</p>
</div>
