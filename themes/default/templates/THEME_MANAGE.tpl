{$REQUIRE_CSS,do_next}

<tr{+START,IF,{$GET,done_one_theme}} class="thick_border"{+END}>
	<td role="note">
		{+START,SET,TOOLTIP}
			<kbd>{NAME*}</kbd>, {!BY_SIMPLE,<em>{AUTHOR`}</em>}
			{+START,IF,{$NEQ,{DATE},{!NA_EM}}}
				{DATE*}
			{+END}
		{+END}

		<strong class="comcode_concept_inline" onmouseover="if (typeof window.activate_tooltip!='undefined') activate_tooltip(this,event,'{$GET;^*,TOOLTIP}','auto');">{TITLE*}</strong>
		<dl>
			{+START,IF_PASSED,SEED}
				<dt>{!SEED_COLOUR}:</dt><dd><strong style="background: white; color: #{SEED*}">{SEED*}</strong></dd>
			{+END}
		</dl>
	</td>
	<td class="manage_theme_export">
		{+START,IF,{$NEQ,{NAME},default}}
			<p><img alt="" src="{$IMG*,icons/24x24/menu/_generic_admin/export}" srcset="{$IMG*,icons/48x48/menu/_generic_admin/export} 2x" /> <a onclick="var t=this; window.fauxmodal_confirm('{!SWITCH_MODULE_WARNING=;}',function(result) { if (result) { click_link(t); } }); return false;" href="{$PAGE_LINK*,adminzone:admin_addons:_addon_export:exp=theme:theme={NAME}}">{!EXPORT_THEME_AS_ADDON}</a></p>
		{+END}
		<p><img alt="" src="{$IMG*,icons/24x24/tabs/preview}" srcset="{$IMG*,icons/48x48/tabs/preview} 2x" /> <a id="theme_preview__{NAME*}" target="_blank" title="{!PREVIEW_THEME} {!LINK_NEW_WINDOW}" href="{$PAGE_LINK*,::keep_theme={NAME}}">{!PREVIEW_THEME}</a></p>
		<p><a href="{SCREEN_PREVIEW_URL*}">{!_SCREEN_PREVIEWS}</a></p>
	</td>
	<td class="do_theme_item" onclick="click_link(this.getElementsByTagName('a')[0]);" onkeypress="if (enter_pressed(event)) return this.onclick.call(this,event);">
		<div><a rel="edit" title="{!EDIT_THEME}: {NAME*}" href="{EDIT_URL*}"><img alt="" src="{$IMG*,icons/48x48/menu/_generic_admin/edit_this}" /></a></div>
		<div><a title="{!EDIT_THEME}: {NAME*}" href="{EDIT_URL*}">{$?,{$IS_EMPTY,{THEME_USAGE}},{!_EDIT_THEME},{!SETTINGS}}</a></div>
	</td>
	<td class="do_theme_item" onclick="click_link(this.getElementsByTagName('a')[0]);" onkeypress="if (enter_pressed(event)) return this.onclick.call(this,event);">
		<div><a rel="edit" title="{!EDIT_CSS}: {NAME*}" href="{CSS_URL*}" onclick="cancel_bubbling(event); if ('{NAME;*}'=='default') { var t=this; window.fauxmodal_confirm('{!EDIT_DEFAULT_THEME_WARNING;}',function(result) { if (result) { click_link(t); } }); return false; } return true;"><img alt="" src="{$IMG*,icons/48x48/menu/adminzone/style/themes/css}" /></a></div>
		<div><a title="{!EDIT_CSS}: {NAME*}" href="{CSS_URL*}" onclick="cancel_bubbling(event); if ('{NAME;*}'=='default') { var t=this; window.fauxmodal_confirm('{!EDIT_DEFAULT_THEME_WARNING;}',function(result) { if (result) { click_link(t); } }); return false; } return true;">{!EDIT_CSS}</a></div>
	</td>
	<td class="do_theme_item" onclick="click_link(this.getElementsByTagName('a')[0]);" onkeypress="if (enter_pressed(event)) return this.onclick.call(this,event);">
		<div><a rel="edit" title="{!EDIT_TEMPLATES}: {NAME*}" href="{TEMPLATES_URL*}" onclick="cancel_bubbling(event); if ('{NAME;*}'=='default') { var t=this; window.fauxmodal_confirm('{!EDIT_DEFAULT_THEME_WARNING;}',function(result) { if (result) { click_link(t); } }); return false; } return true;"><img alt="" src="{$IMG*,icons/48x48/menu/adminzone/style/themes/templates}" /></a></div>
		<div><a title="{!EDIT_TEMPLATES}: {NAME*}" href="{TEMPLATES_URL*}" onclick="cancel_bubbling(event); if ('{NAME;*}'=='default') { var t=this; window.fauxmodal_confirm('{!EDIT_DEFAULT_THEME_WARNING;}',function(result) { if (result) { click_link(t); } }); return false; } return true;">{!EDIT_TEMPLATES}</a></div>
	</td>
	<td class="do_theme_item" onclick="click_link(this.getElementsByTagName('a')[0]);" onkeypress="if (enter_pressed(event)) return this.onclick.call(this,event);">
		<div><a rel="edit" title="{!EDIT_THEME_IMAGES}: {NAME*}" href="{IMAGES_URL*}" onclick="cancel_bubbling(event); if ('{NAME;*}'=='default') { var t=this; window.fauxmodal_confirm('{!EDIT_DEFAULT_THEME_WARNING;}',function(result) { if (result) { click_link(t); } }); return false; } return true;"><img alt="" src="{$IMG*,icons/48x48/menu/adminzone/style/themes/theme_images}" /></a></div>
		<div><a title="{!EDIT_THEME_IMAGES}: {NAME*}" href="{IMAGES_URL*}" onclick="cancel_bubbling(event); if ('{NAME;*}'=='default') { var t=this; fauxmodal_confirm('{!EDIT_DEFAULT_THEME_WARNING;}',function(result) { if (result) { click_link(t); } }); return false; } return true;">{!EDIT_THEME_IMAGES}</a></div>
	</td>
</tr>
<tr>
	<td colspan="6" class="manage_theme_theme_usage">
		{+START,IF_NON_EMPTY,{THEME_USAGE}}{THEME_USAGE*}{+END}
		{+START,IF,{$EQ,{NAME},default}}
			<p>{!DEFAULT_THEME_INHERITANCE}</p>
		{+END}
	</td>
</tr>

{$SET,done_one_theme,1}
