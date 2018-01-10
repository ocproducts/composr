<tr id="access_{GROUP_ID*}_privilege_container" class="{$CYCLE,permissions_zebra,zebra-0,zebra-1}">
	<th class="form-table-field-name">
		<p class="form-field-name field-name">{GROUP_NAME*}</p>
	</th>

	<td class="form-table-field-input">
		<div class="accessibility-hidden"><label for="access_{GROUP_ID*}">{PINTERFACE_VIEW*} ({GROUP_NAME*})</label></div>
		<input id="access_{GROUP_ID*}" title="{PINTERFACE_VIEW*} ({!ADMIN})" name="_ignore" type="checkbox" checked="checked" disabled="disabled" class="no_tooltip" />
	</td>

	{+START,LOOP,OVERRIDES}
		<td class="form-table-field-input">
			<div class="accessibility-hidden"><label for="access_{GROUP_ID*}_{_loop_key*}">{!NA}</label></div>
			<input name="_ignore" type="checkbox" id="access_{GROUP_ID*}_{_loop_key*}" checked="checked" disabled="disabled" />
		</td>
	{+END}

	{+START,IF,{$OR,{FORCE_PRESETS},{$IS_NON_EMPTY,{OVERRIDES}}}}
		<td class="form-table-field-input">
		</td>
	{+END}
</tr>
