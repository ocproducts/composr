{TITLE}

{+START,INCLUDE,HANDLE_CONFLICT_RESOLUTION}{+END}
{+START,IF_PASSED,WARNING_DETAILS}
	{WARNING_DETAILS}
{+END}

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
			{THEMES}
		</tbody>
	</table>

	<div class="theme_manage_footnote">
		{+START,IF,{$AND,{$HAS_FORUM},{HAS_FREE_CHOICES}}}
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

<ul role="navigation" class="actions_list">
	<li><a href="{$PAGE_LINK*,adminzone:admin_themewizard:browse}">{!THEMEWIZARD}</a></li>
	<li><a href="{$PAGE_LINK*,adminzone:admin_themes:add_theme}">{!ADD_EMPTY_THEME}</a></li>
</ul>

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
