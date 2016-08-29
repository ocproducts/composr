<tr id="access_{GROUP_ID*}_privilege_container" class="{$CYCLE,permissions_zebra,zebra_0,zebra_1}">
	<th class="form_table_field_name">
		<p class="form_field_name field_name">{GROUP_NAME*}</p>
	</th>

	<td class="form_table_field_input">
		<div class="accessibility_hidden"><label for="access_{GROUP_ID*}">{PINTERFACE_VIEW*} ({GROUP_NAME*})</label></div>
		<input id="access_{GROUP_ID*}" title="{PINTERFACE_VIEW*} ({!ADMIN})" name="_ignore" type="checkbox" checked="checked" disabled="disabled" class="no_tooltip" />
	</td>

	{+START,LOOP,OVERRIDES}
		<td class="form_table_field_input">
			<div class="accessibility_hidden"><label for="access_{GROUP_ID*}_{_loop_key*}">{!NA}</label></div>
			<input name="_ignore" type="checkbox" id="access_{GROUP_ID*}_{_loop_key*}" checked="checked" disabled="disabled" />
		</td>
	{+END}

	{+START,IF,{$OR,{FORCE_PRESETS},{$IS_NON_EMPTY,{OVERRIDES}}}}
		{+START,IF,{$JS_ON}}
			<td class="form_table_field_input">
			</td>
		{+END}
	{+END}
</tr>
