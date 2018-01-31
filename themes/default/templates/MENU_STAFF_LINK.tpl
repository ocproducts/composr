{+START,IF,{$THEME_OPTION,enable_menu_editor_buttons}}
	<a class="edit-menu-link-inline" href="{EDIT_URL*}" title="{!EDIT_MENU}{+START,IF_NON_EMPTY,{NAME}}: {NAME*}{+END}"><img class="vertical-alignment" alt="{!EDIT_MENU}" width="16" height="16" src="{$IMG*,icons/menus/menu}" /></a>
{+END}
