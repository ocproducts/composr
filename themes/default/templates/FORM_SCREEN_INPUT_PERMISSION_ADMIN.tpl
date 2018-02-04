<tr id="access-{GROUP_ID*}-privilege-container" class="{$CYCLE,permissions_zebra,zebra-0,zebra-1}">
	<th class="form-table-field-name">
		<p class="form-field-name field-name">{GROUP_NAME*}</p>
	</th>

	<td class="form-table-field-input">
		<div class="accessibility-hidden"><label for="access-{GROUP_ID*}">{PINTERFACE_VIEW*} ({GROUP_NAME*})</label></div>
		<input id="access-{GROUP_ID*}" title="{PINTERFACE_VIEW*} ({!ADMIN})" name="_ignore" type="checkbox" checked="checked" disabled="disabled" class="no-tooltip" />
	</td>

	{+START,LOOP,OVERRIDES}
		<td class="form-table-field-input">
			<div class="accessibility-hidden"><label for="access-{GROUP_ID*}-{_loop_key*}">{!NA}</label></div>
			<input name="_ignore" type="checkbox" id="access-{GROUP_ID*}-{_loop_key*}" checked="checked" disabled="disabled" />
		</td>
	{+END}

	{+START,IF,{$OR,{FORCE_PRESETS},{$IS_NON_EMPTY,{OVERRIDES}}}}
		<td class="form-table-field-input">
		</td>
	{+END}
</tr>
