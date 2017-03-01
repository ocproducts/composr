{TITLE}

{+START,INCLUDE,HANDLE_CONFLICT_RESOLUTION}{+END}
{+START,IF_PASSED,WARNING_DETAILS}
	{WARNING_DETAILS}
{+END}

{$REQUIRE_CSS,do_next}

<h2>{!EXISTING_THEMES}</h2>

<div class="autosized_table theme_manage_table">
	<table class="columned_table">
		<thead>
			<tr>
				<th>{!THEME}</th>
				<th>{!TOOLS}</th>
				<th colspan="4">{!EDIT}</th>
			</tr>
		</thead>
		<tbody>
			{$SET,done_one_theme,0}
			{+START,LOOP,THEMES}
				<tr class="{+START,IF,{$GET,done_one_theme}}thick_border{+END}{+START,IF,{IS_MAIN_THEME}} active_item{+END}">
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
							<p><img alt="" src="{$IMG*,icons/24x24/menu/_generic_admin/export}" srcset="{$IMG*,icons/48x48/menu/_generic_admin/export} 2x" /> <a onclick="var t=this; window.fauxmodal_confirm('{!SWITCH_MODULE_WARNING=;}',function(result) { if (result) { click_link(t); } }); return false;" href="{$PAGE_LINK*,adminzone:admin_addons:_addon_export:exp=theme:theme={NAME}}">{!addons:EXPORT_THEME}</a></p>
						{+END}
						<p><img alt="" src="{$IMG*,icons/24x24/menu/start}" srcset="{$IMG*,icons/48x48/menu/start} 2x" /> <a id="theme_preview__{NAME*}" target="_blank" title="{!PREVIEW_THEME} {!LINK_NEW_WINDOW}" href="{$PAGE_LINK*,::keep_theme={NAME}}">{!PREVIEW_THEME}</a></p>
						<p><img alt="" src="{$IMG*,icons/24x24/tabs/preview}" srcset="{$IMG*,icons/48x48/tabs/preview} 2x" /> <a href="{SCREEN_PREVIEW_URL*}">{!_SCREEN_PREVIEWS}</a></p>
					</td>
					<td class="do_theme_item" onclick="click_link(this);" onkeypress="if (enter_pressed(event)) return this.onclick.call(this,event);">
						<div><a rel="edit" title="{!EDIT_THEME}: {NAME*}" href="{EDIT_URL*}"><img alt="" src="{$IMG*,icons/48x48/menu/_generic_admin/edit_this}" /></a></div>
						<div><a title="{!EDIT_THEME}: {NAME*}" href="{EDIT_URL*}">{$?,{$IS_EMPTY,{THEME_USAGE}},{!_EDIT_THEME},{!SETTINGS}}</a></div>
					</td>
					<td class="do_theme_item" onclick="click_link(this);" onkeypress="if (enter_pressed(event)) return this.onclick.call(this,event);">
						<div><a rel="edit" title="{!EDIT_CSS}: {NAME*}" href="{CSS_URL*}" onclick="cancel_bubbling(event); if ('{NAME;*}'=='default') { var t=this; window.fauxmodal_confirm('{!EDIT_DEFAULT_THEME_WARNING;}',function(result) { if (result) { click_link(t); } }); return false; } return true;"><img alt="" src="{$IMG*,icons/48x48/menu/adminzone/style/themes/css}" /></a></div>
						<div><a title="{!EDIT_CSS}: {NAME*}" href="{CSS_URL*}" onclick="cancel_bubbling(event); if ('{NAME;*}'=='default') { var t=this; window.fauxmodal_confirm('{!EDIT_DEFAULT_THEME_WARNING;}',function(result) { if (result) { click_link(t); } }); return false; } return true;">{!EDIT_CSS}</a></div>
					</td>
					<td class="do_theme_item" onclick="click_link(this);" onkeypress="if (enter_pressed(event)) return this.onclick.call(this,event);">
						<div><a rel="edit" title="{!EDIT_TEMPLATES}: {NAME*}" href="{TEMPLATES_URL*}" onclick="cancel_bubbling(event); if ('{NAME;*}'=='default') { var t=this; window.fauxmodal_confirm('{!EDIT_DEFAULT_THEME_WARNING;}',function(result) { if (result) { click_link(t); } }); return false; } return true;"><img alt="" src="{$IMG*,icons/48x48/menu/adminzone/style/themes/templates}" /></a></div>
						<div><a title="{!EDIT_TEMPLATES}: {NAME*}" href="{TEMPLATES_URL*}" onclick="cancel_bubbling(event); if ('{NAME;*}'=='default') { var t=this; window.fauxmodal_confirm('{!EDIT_DEFAULT_THEME_WARNING;}',function(result) { if (result) { click_link(t); } }); return false; } return true;">{!EDIT_TEMPLATES}</a></div>
					</td>
					<td class="do_theme_item" onclick="click_link(this);" onkeypress="if (enter_pressed(event)) return this.onclick.call(this,event);">
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
			{+END}
		</tbody>
	</table>

	<div class="theme_manage_footnote">
		{+START,IF,{$AND,{$HAS_FORUM,1},{HAS_FREE_CHOICES}}}
			<p><sup>*</sup> {!MEMBERS_MAY_ALTER_THEME}</p>
		{+END}

		{+START,IF_NON_EMPTY,{THEME_DEFAULT_REASON}}
			<p><sup>*</sup> {THEME_DEFAULT_REASON}</p>
		{+END}
	</div>
</div>

<script>// <![CDATA[
	load_previews();
//]]></script>

<h2>{!ADD_THEME}</h2>

<nav>
	<ul class="actions_list">
		{+START,IF,{$ADDON_INSTALLED,themewizard}}
			<li><a href="{$PAGE_LINK*,adminzone:admin_themewizard:browse}">{!THEMEWIZARD}</a></li>
		{+END}
		<li><a href="{$PAGE_LINK*,adminzone:admin_themes:add_theme}">{!ADD_EMPTY_THEME}</a></li>
	</ul>
</nav>

<h2>{!THEME_EXPORT}</h2>

<div class="box box___theme_manage_screen"><div class="box_inner help_jumpout">
	<p>
		{!IMPORT_EXPORT_THEME_HELP,{$PAGE_LINK*,adminzone:admin_addons:addon_import}}
	</p>
</div></div>

{+START,IF,{$GT,{ZONES},6}}
	<h2>{!ZONES}</h2>

	<p class="lonely_label">{!THEMES_AND_ZONES}</p>
	<ul>
		{+START,LOOP,ZONES}
			<li>{1*} <span class="associated_link"><a title="edit: {!EDIT_ZONE}: {1*}" onclick="var t=this; window.fauxmodal_confirm('{!SWITCH_MODULE_WARNING=;}',function(result) { if (result) { click_link(t); } }); return false;" href="{$PAGE_LINK*,_SEARCH:admin_zones:_edit:{0}:redirect={$SELF_URL&}}">{!EDIT}</a></span></li>
		{+END}
	</ul>
{+END}
