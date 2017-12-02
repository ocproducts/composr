<div data-view="PermissionsTreeEditorScreen" data-view-params="{+START,PARAMS_JSON,COLOR,USERGROUPS}{_*}{+END}">
	{TITLE}

	<p>{!PERMISSIONS_TREE_EDITOR_ABOUT_PRIVILEGE,{$PAGE_LINK*,adminzone:admin_permissions:specific}}</p>

	<div class="float-surrounder">
		<div class="pte_help_box">
			<div class="box box___permissions_tree_editor_screen"><div class="box_inner">
				<h2>{!PERMISSIONS_TREE_EDITOR_HOW_WORK}</h2>

				<p class="vertical_alignment">{!PERMISSIONS_TREE_EDITOR_ABOUT_BARRIERS,<img src="{$IMG*,led_on}" alt="" />}</p>

				<p class="vertical_alignment">{!PERMISSIONS_TREE_EDITOR_ABOUT_GROUP,<img src="{$IMG*,permlevels/3}" alt="" />}</p>

				<p class="pte_tips">{!PERMISSIONS_TREE_EDITOR_ABOUT_MULTI_SELECT}</p>

				<p class="pte_tips">{!PERMISSIONS_TREE_EDITOR_ABOUT_HOVER_FOR_PERMISSIONS}</p>

				<p class="pte_tips">{!PERMISSIONS_TREE_EDITOR_INHERIT}</p>
			</div></div>
		</div>

		<div>
			<div class="box box___permissions_tree_editor_screen"><div class="box_inner">
				<h2>{!SITEMAP}</h2>

				<div class="pte_tree">
					<div class="pte_icon_box">
						<div class="box box___permissions_tree_editor_screen"><div class="box_inner">
							<form title="{!CHOOSE} {!USERGROUP}" action="index.php" method="post" autocomplete="off">
								<img alt="" src="{$IMG*,pte_view_help}" /><strong><label for="group">{!PERMISSIONS_TREE_EDITOR_ICON_LABEL}:</label></strong>
								<select id="group" name="group" class="js-click-update-group js-change-update-group">
									{GROUPS}
								</select>
							</form>
							<p>{!PERMISSIONS_TREE_EDITOR_ICON_SPECIFIC,<span id="group_name">{INITIAL_GROUP*}</span>}</p>
						</div></div>
					</div>

					<form title="{!PRIMARY_PAGE_FORM}" action="index.php" method="post" autocomplete="off">
						<div class="accessibility_hidden"><label for="tree_list">{!ENTRY}</label></div>
						<input class="js-change-update-perm-box" style="display: none" type="text" id="tree_list" name="tree_list" value="{$_GET*,id}" />
					</form>
					<div id="tree_list__root_tree_list" class="tree_list__root_tree_list pt_editor">
						<!-- List put in here -->
					</div>
				</div>
			</div></div>
		</div>
	</div>

	<div class="pte_set_box">
		<div class="box box___permissions_tree_editor_screen"><div class="box_inner">
			<h2>{!PERMISSIONS_TREE_EDITOR_PERMISSIONS_FOR_SELECTION}</h2>

			<p>
				{!PERMISSION_INHERITANCE_HOVER}
			</p>

			<form id="permissions_form" title="{!PRIMARY_PAGE_FORM}" method="post" action="index.php" autocomplete="off">
				{$INSERT_SPAMMER_BLACKHOLE}

				<div class="float-surrounder">
					<div style="display: none" id="selection_form_fields">
						{EDITOR}
					</div>

					<p class="right" id="selection_message">
						<em>{!PERMISSIONS_TREE_EDITOR_NONE_SELECTED}</em>
					</p>
					<div>
						<input type="button" class="button_screen_item buttons__save js-click-set-permissions" id="selection_button" disabled="disabled" value="{!SET}" />
					</div>
				</div>
			</form>
		</div></div>
	</div>
</div>
