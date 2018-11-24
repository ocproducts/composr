<div data-tpl="formScreenInputTreeList" data-tpl-params="{+START,PARAMS_JSON,NAME,HOOK,ROOT_ID,OPTIONS,MULTI_SELECT,TABINDEX,USE_SERVER_ID}{_*}{+END}">
	{+START,INCLUDE,FORM_SCREEN_FIELD_DESCRIPTION}
		DESCRIPTION={+START,IF_NON_EMPTY,{DESCRIPTION}}{DESCRIPTION}<br /><br />{+END}{!TREE_LIST_HELP,{$?,{_REQUIRED},{!TREE_LIST_HELP_DESELECT}},{$?,{$EQ,{$PAGE},admin_sitemap,admin_permissions},{!TREE_LIST_HELP_MASS_EXPAND}},{CONTENT_TYPE}}
		RIGHT=1
	{+END}

	<input style="display: none" type="text" class="form-control input-line{REQUIRED*} hidden-but-needed js-input-change-update-mirror" id="{NAME*}" name="{NAME*}" value="{DEFAULT*}" />
	<div class="ajax-tree-list" id="tree-list--root-{NAME*}" role="tree">
		<!-- List put in here -->
	</div>

	{+START,IF_NON_EMPTY,{DEFAULT}}
		<p class="associated-details">
			{!TREE_LIST_FEEDBACK,<span class="whitespace-visible" id="{NAME*}-mirror">{NICE_LABEL*}</span>}
		</p>
	{+END}
</div>
