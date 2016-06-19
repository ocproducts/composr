{TITLE}

<p>{!PERMISSIONS_TREE_EDITOR_ABOUT_PRIVILEGE,{$PAGE_LINK*,adminzone:admin_permissions:specific}}</p>

<div class="float_surrounder">
	<div class="pte_help_box">
		<div class="box box___permissions_tree_editor_screen"><div class="box_inner">
			<h2>{!PERMISSIONS_TREE_EDITOR_HOW_WORK}</h2>

			<p>{!PERMISSIONS_TREE_EDITOR_ABOUT_BARRIERS,<img src="{$IMG*,led_on}" alt="" />}</p>

			<p>{!PERMISSIONS_TREE_EDITOR_ABOUT_GROUP,<img src="{$IMG*,permlevels/3}" alt="" />}</p>

			<p class="pte_tips">{!PERMISSIONS_TREE_EDITOR_ABOUT_MULTI_SELECT}</p>

			<p class="pte_tips">{!PERMISSIONS_TREE_EDITOR_ABOUT_HOVER_FOR_PERMISSIONS}</p>

			<p class="pte_tips">{!PERMISSIONS_TREE_EDITOR_INHERIT}</p>
		</div></div>
	</div>

	<div>
		<div class="box box___permissions_tree_editor_screen"><div class="box_inner">
			<h2>{!SITEMAP}</h2>

			<div class="pte_tree">
				<!-- onmouseover="fade_icons_out();" onmouseout="fade_icons_in();" firefox too buggy -->
				<div class="pte_icon_box">
					<div class="box box___permissions_tree_editor_screen"><div class="box_inner">
						<form title="{!CHOOSE} {!USERGROUP}" action="index.php" method="post" autocomplete="off">
							<img alt="" src="{$IMG*,pte_view_help}" /><strong><label for="group">{!PERMISSIONS_TREE_EDITOR_ICON_LABEL}:</label></strong>
							<select id="group" name="group" onclick="this.onchange(event);" onchange="update_group_displayer(this)">
								{GROUPS}
							</select>
						</form>
						<p>{!PERMISSIONS_TREE_EDITOR_ICON_SPECIFIC,<span id="group_name">{INITIAL_GROUP*}</span>}</p>
					</div></div>
				</div>

				<form title="{!PRIMARY_PAGE_FORM}" action="index.php" method="post" autocomplete="off">
					<div class="accessibility_hidden"><label for="tree_list">{!ENTRY}</label></div>
					<input onchange="update_permission_box(this)" style="display: none" type="text" id="tree_list" name="tree_list" value="{$_GET*,id}" />
				</form>
				<div id="tree_list__root_tree_list" class="tree_list__root_tree_list pt_editor">
					<!-- List put in here -->
				</div>
				<script>// <![CDATA[
					add_event_listener_abstract(window,'load',function() {
						window.sitemap=new tree_list('tree_list','data/sitemap.php?start_links=1&get_perms=1&label_content_types=1&keep_full_structure=1{$KEEP;/}',null,'',true);
					});
					var column_color='{COLOR;/}';

					window.usergroup_titles={};
					{+START,LOOP,USERGROUPS}
						window.usergroup_titles[{_loop_key%}]='{_loop_var;/}';
					{+END}
				//]]></script>
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

			<div class="float_surrounder">
				<div style="display: none" id="selection_form_fields">
					{EDITOR}
				</div>

				<p class="right" id="selection_message">
					<em>{!PERMISSIONS_TREE_EDITOR_NONE_SELECTED}</em>
				</p>
				<div>
					<input type="button" class="button_screen_item buttons__save" id="selection_button" disabled="disabled" value="{!SET}" onclick="set_permissions(document.getElementById('tree_list'));" />
				</div>
			</div>
		</form>
	</div></div>
</div>
