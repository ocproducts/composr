{$REQUIRE_JAVASCRIPT,core_form_interfaces}
<td class="form_table_field_input privilege_cell" data-tpl-core-form-interfaces="formScreenInputPermissionOverride" data-tpl-args="{+START,PARAMS_JSON,GROUP_ID,DEFAULT_ACCESS,PRIVILEGE,TITLE,ALL_GLOBAL}{_*}{+END}">
	<div class="accessibility_hidden"><label for="access_{GROUP_ID*}_privilege_{PRIVILEGE*}">{!OVERRIDE} ({GROUP_NAME*}, {TITLE*})</label></div>
	<select onclick="this.onchange(event);" onchange="permissions_overridden('access_{GROUP_ID%}');" onmouseover="if (this.options[this.selectedIndex].value=='-1') show_permission_setting(this,event);" tabindex="{TABINDEX*}" title="{TITLE*}" id="access_{GROUP_ID*}_privilege_{PRIVILEGE*}" name="access_{GROUP_ID*}_privilege_{PRIVILEGE*}">
		{$,The order of options here should not be changed with unless JavaScript is also recoded}
		{+START,IF,{$EQ,{CODE},-1}}
			<option selected="selected" value="-1">/</option>
		{+END}
		{+START,IF,{$NEQ,{CODE},-1}}
			<option value="-1">{!USE_DEFAULT}</option>
		{+END}
		{+START,IF,{$EQ,{CODE},0}}
			<option selected="selected" value="0">{!NO_COMPACT}</option>
		{+END}
		{+START,IF,{$NEQ,{CODE},0}}
			<option value="0">{!NO_COMPACT}</option>
		{+END}
		{+START,IF,{$EQ,{CODE},1}}
			<option selected="selected" value="1">{!YES_COMPACT}</option>
		{+END}
		{+START,IF,{$NEQ,{CODE},1}}
			<option value="1">{!YES_COMPACT}</option>
		{+END}
	</select>
</td>
