{$REQUIRE_JAVASCRIPT,core_form_interfaces}

<td class="form-table-field-input privilege-cell" data-view="FormScreenInputPermissionOverride" data-view-params="{+START,PARAMS_JSON,GROUP_ID,DEFAULT_ACCESS,PRIVILEGE,TITLE,ALL_GLOBAL}{_*}{+END}">
	<div class="accessibility-hidden"><label for="access_{GROUP_ID*}_privilege_{PRIVILEGE*}">{!OVERRIDE} ({GROUP_NAME*}, {TITLE*})</label></div>
	<select class="form-control js-click-perms-overridden js-change-perms-overridden js-mouseover-show-perm-setting" tabindex="{TABINDEX*}" title="{TITLE*}" id="access_{GROUP_ID*}_privilege_{PRIVILEGE*}" name="access_{GROUP_ID*}_privilege_{PRIVILEGE*}">
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
