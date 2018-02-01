{$REQUIRE_JAVASCRIPT,core_menus}

<div data-tpl="menuEditorScreen" data-tpl-params="{+START,PARAMS_JSON,ALL_MENUS}{_*}{+END}">
	{TITLE}

	{+START,INCLUDE,HANDLE_CONFLICT_RESOLUTION}{+END}
	{+START,IF_PASSED,WARNING_DETAILS}
		{WARNING_DETAILS}
	{+END}

	<div class="menu-editor-page{+START,IF,{$GT,{TOTAL_ITEMS},10}} docked{+END} js-el-menu-editor-wrap" id="menu_editor_wrap">
		<form title="" action="{URL*}" method="post" autocomplete="off">
			<!-- In separate form due to mod_security -->
			<textarea aria-hidden="true" cols="30" rows="3" style="display: none" name="template" id="template">{CHILD_BRANCH_TEMPLATE*}</textarea>
		</form>

		<form title="{!PRIMARY_PAGE_FORM}" id="edit_form" action="{URL*}" method="post" autocomplete="off" class="js-submit-modsecurity-workaround" data-submit-pd="1">
			{$INSERT_SPAMMER_BLACKHOLE}

			<div class="float-surrounder menu-edit-main">
				<div class="menu-editor-rh-side">
					<h2>{!HELP}</h2>

					<p>{!BRANCHES_DESCRIPTION,{$PAGE_LINK*,_SEARCH:admin_sitemap:browse}}</p>

					<p>{!ENTRY_POINTS_DESCRIPTION}</p>
				</div>

				<div class="menu-editor-lh-side">
					<h2>{!BRANCHES}</h2>

					<input type="hidden" name="highest_order" id="highest_order" value="{HIGHEST_ORDER*}" />

					<div class="menu-editor-root">
						{ROOT_BRANCH}
					</div>
				</div>

				<p class="proceed-button">
					<input accesskey="u" class="button-screen buttons--save js-click-check-menu" type="submit" value="{!SAVE}" />
				</p>
			</div>

			<div id="mini-form-hider" style="display: none" class="float-surrounder">
				<div class="menu-editor-rh-side">
					<img class="dock-button js-img-click-toggle-docked-field-editing" alt="" title="{!TOGGLE_DOCKED_FIELD_EDITING}" width="13" height="13" src="{$IMG*,icons/arrow_box/arrow_box_hover}" />

					<h2>{!CHOOSE_ENTRY_POINT}</h2>

					<div class="accessibility-hidden"><label for="tree_list">{!ENTRY}</label></div>
					<input class="js-input-change-update-selection" style="display: none" type="text" id="tree_list" name="tree_list" />
					<div id="tree-list--root-tree-list">
						<!-- List put in here -->
					</div>

					<p class="associated-details">
						{!CLICK_ENTRY_POINT_TO_USE}
					</p>

					<nav>
						<ul class="actions-list">
							<li><a href="#!" class="js-click-menu-editor-add-new-page">{!SPECIFY_NEW_PAGE}</a></li>
						</ul>
					</nav>
				</div>

				<div class="menu-editor-lh-side">
					<h2>{!EDIT_SELECTED_FIELD}</h2>

					<div class="wide-table-wrap"><table class="map-table form-table wide-table">
						{+START,IF,{$DESKTOP}}
							<colgroup>
								<col class="field-name-column" />
								<col class="field-input-column" />
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

		<div class="box box---menu-editor-screen" data-toggleable-tray="{}">
			<h2 class="toggleable-tray-title">
				<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!"><img alt="{!EXPAND}: {!DELETE_MENU}" title="{!EXPAND}" width="24" height="24" src="{$IMG*,icons/trays/expand2}" /></a>
				<a class="toggleable-tray-button js-tray-onclick-toggle-tray" href="#!">{!DELETE_MENU}</a>
			</h2>

			<div class="toggleable-tray js-tray-content" id="delete-menu" style="display: none" aria-expanded="false">
				<p>{!ABOUT_DELETE_MENU}</p>

				<form title="{!DELETE}" action="{DELETE_URL*}" method="post" autocomplete="off">
					{$INSERT_SPAMMER_BLACKHOLE}

					<p class="proceed-button">
						<input type="hidden" name="confirm" value="1" />
						<input type="hidden" name="delete_confirm" value="1" />

						<input class="button-screen-item admin--delete3" type="submit" value="{!DELETE}" data-cms-confirm-click="{!CONFIRM_DELETE*,{MENU_NAME}}" />
					</p>
				</form>
			</div>
		</div>
	</div>
</div>
