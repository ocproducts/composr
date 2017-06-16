{$REQUIRE_JAVASCRIPT,core_menus}

<div data-tpl="menuEditorScreen" data-tpl-params="{+START,PARAMS_JSON,ALL_MENUS}{_*}{+END}">
	{TITLE}

	{+START,INCLUDE,HANDLE_CONFLICT_RESOLUTION}{+END}
	{+START,IF_PASSED,WARNING_DETAILS}
		{WARNING_DETAILS}
	{+END}

	<div class="menu_editor_page docked js-el-menu-editor-wrap" id="menu_editor_wrap">
		<form title="" action="{URL*}" method="post" autocomplete="off">
			<!-- In separate form due to mod_security -->
			<textarea aria-hidden="true" cols="30" rows="3" style="display: none" name="template" id="template">{CHILD_BRANCH_TEMPLATE*}</textarea>
		</form>

		<form title="{!PRIMARY_PAGE_FORM}" id="edit_form" action="{URL*}" method="post" autocomplete="off" class="js-submit-modsecurity-workaround" data-submit-pd="1">
			{$INSERT_SPAMMER_BLACKHOLE}

			<div class="float_surrounder menu_edit_main">
				<div class="menu_editor_rh_side">
					<h2>{!HELP}</h2>

					<p>{!BRANCHES_DESCRIPTION,{$PAGE_LINK*,_SEARCH:admin_sitemap:browse}}</p>

					<p>{!ENTRY_POINTS_DESCRIPTION}</p>
				</div>

				<div class="menu_editor_lh_side">
					<h2>{!BRANCHES}</h2>

					<input type="hidden" name="highest_order" id="highest_order" value="{HIGHEST_ORDER*}" />

					<div class="menu_editor_root">
						{ROOT_BRANCH}
					</div>
				</div>

				<p class="proceed_button">
					<input accesskey="u" class="button_screen buttons__save js-click-check-menu" type="submit" value="{!SAVE}" />
				</p>
			</div>

			<div id="mini_form_hider" style="display: none" class="float_surrounder">
				<div class="menu_editor_rh_side">
					<img class="dock_button js-img-click-toggle-docked-field-editing js-img-keypress-toggle-docked-field-editing" alt="" title="{!TOGGLE_DOCKED_FIELD_EDITING}" src="{$IMG*,1x/arrow_box_hover}" srcset="{$IMG*,2x/arrow_box_hover} 2x" />

					<h2>{!CHOOSE_ENTRY_POINT}</h2>

					<div class="accessibility_hidden"><label for="tree_list">{!ENTRY}</label></div>
					<input class="js-input-change-update-selection" style="display: none" type="text" id="tree_list" name="tree_list" value="" />
					<div id="tree_list__root_tree_list">
						<!-- List put in here -->
					</div>

					<p class="associated_details">
						{!CLICK_ENTRY_POINT_TO_USE}
					</p>

					<nav>
						<ul class="actions_list">
							<li><a href="#!" class="js-click-menu-editor-add-new-page">{!SPECIFY_NEW_PAGE}</a></li>
						</ul>
					</nav>
				</div>

				<div class="menu_editor_lh_side">
					<h2>{!EDIT_SELECTED_FIELD}</h2>

					<div class="wide_table_wrap"><table class="map_table form_table wide_table">
						{+START,IF,{$NOT,{$MOBILE}}}
							<colgroup>
								<col class="field_name_column" />
								<col class="field_input_column" />
							</colgroup>
						{+END}

						<tbody>
							{FIELDS_TEMPLATE}
						</tbody>
					</table></div>
				</div>
			</div>

			<input type="hidden" name="confirm" value="1" />
		</form>

		<div class="box box___menu_editor_screen" data-view="ToggleableTray">
			<h2 class="toggleable_tray_title">
				<a class="toggleable_tray_button js-btn-tray-toggle" href="#!"><img alt="{!EXPAND}: {!DELETE_MENU}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand2}" srcset="{$IMG*,2x/trays/expand2} 2x" /></a>
				<a class="toggleable_tray_button js-btn-tray-toggle" href="#!">{!DELETE_MENU}</a>
			</h2>

			<div class="toggleable_tray js-tray-content" id="delete_menu" style="display: none" aria-expanded="false">
				<p>{!ABOUT_DELETE_MENU}</p>

				<form title="{!DELETE}" action="{DELETE_URL*}" method="post" autocomplete="off">
					{$INSERT_SPAMMER_BLACKHOLE}

					<p class="proceed_button">
						<input type="hidden" name="confirm" value="1" />
						<input type="hidden" name="delete_confirm" value="1" />

						<input class="button_screen_item menu___generic_admin__delete" type="submit" value="{!DELETE}" data-cms-confirm-click="{!CONFIRM_DELETE*,{MENU_NAME}}" />
					</p>
				</form>
			</div>
		</div>
	</div>
</div>
