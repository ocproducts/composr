{+START,IF,{$THEME_OPTION,enable_menu_editor_buttons}}
	<a class="edit_menu_link_inline" href="{EDIT_URL*}" title="{!EDIT_MENU}{+START,IF_NON_EMPTY,{NAME}}: {NAME*}{+END}"><img width="17" height="17" class="vertical-alignment" alt="{!EDIT_MENU}" src="{$IMG*,1x/menus/menu}" srcset="{$IMG*,2x/menus/menu} 2x" /></a>
{+END}
