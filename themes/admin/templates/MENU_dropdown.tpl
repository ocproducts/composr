{$REQUIRE_CSS,menu__dropdown}
{$REQUIRE_JAVASCRIPT,core_menus}

{+START,IF_NON_EMPTY,{CONTENT}}

{$SET,menu_id,r-{MENU|}-d}
{$SET,RAND,{$RAND}}
{$SET,HAS_CHILDREN,{$HAS_ACTUAL_PAGE_ACCESS,admin,adminzone}}

<div class="dropdown-menu dropdown-menu-admin" data-view="DropdownMenu" data-view-params="{+START,PARAMS_JSON,MENU,JAVASCRIPT_HIGHLIGHTING,menu_id}{_*}{+END}">
	<a href="{$PAGE_LINK*,:sitemap}" class="dropdown-menu-toggle-btn">{+START,INCLUDE,ICON}NAME=menus/mobile_menu{+END} <span>{!MENU}</span></a>

	<nav class="dropdown-menu-content js-el-menu-content">
		<ul class="dropdown-menu-items dropdown-menu-items-main nl" id="{$GET*,menu_id}">
			{CONTENT}

			<li class="dropdown-menu-item non-current last toplevel {$?,{$GET,HAS_CHILDREN},has-children}" data-vw-rand="{$GET*,RAND}">
				<a href="{$TUTORIAL_URL*,tutorials}" class="dropdown-menu-item-a toplevel-link last" title="{!menus:MM_TOOLTIP_DOCS}"{$?,{$GET,HAS_CHILDREN}, data-vw-sub-menu-id="{MENU|*}-dexpand-{$GET*,RAND}"}>
					<span class="dropdown-menu-item-icon">{+START,INCLUDE,ICON}NAME=help{+END}</span>
					<span class="dropdown-menu-item-caption">{!HELP}</span>
				</a>
				{+START,IF,{$GET,HAS_CHILDREN}}
				<div aria-haspopup="true" class="dropdown-menu-items dropdown-menu-item-popup nlevel menu-help-section" id="{MENU|*}-dexpand-{$GET*,RAND}" style="display: none">
					{+START,INCLUDE,ADMIN_ZONE_SEARCH}{+END}
				</div>
				{+END}
			</li>
		</ul>
	</nav>
</div>

{+END}
