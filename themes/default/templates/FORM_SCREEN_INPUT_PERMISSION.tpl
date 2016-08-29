<tr id="access_{GROUP_ID*}_privilege_container" class="{$CYCLE,permissions_zebra,zebra_0,zebra_1}">
	<th class="form_table_field_name">
		<p class="form_field_name field_name">{GROUP_NAME*}</p>
		{+START,IF,{$OR,{FORCE_PRESETS},{$IS_NON_EMPTY,{OVERRIDES}}}}
			<label for="access_{GROUP_ID*}_presets">
				<span class="accessibility_hidden">{!PINTERFACE_PRESETS} ({GROUP_NAME*})</span>

				<select tabindex="{TABINDEX*}" id="access_{GROUP_ID*}_presets" name="access_{GROUP_ID*}_presets" onkeypress="if (enter_pressed(event)) this.onclick(event);" onclick="this.onchange(event);" onchange="copy_permission_presets('access_{GROUP_ID;*}',this.options[this.selectedIndex].value); cleanup_permission_list('access_{GROUP_ID;*}')">
					{+START,IF,{ALL_GLOBAL}}
						<option selected="selected" value="-1">{!PINTERFACE_LEVEL_GLOBAL}</option>
					{+END}
					{+START,IF,{$NOT,{ALL_GLOBAL}}}
						<option id="access_{GROUP_ID*}_custom_option" selected="selected" value="">{!PINTERFACE_LEVEL_CUSTOM}</option>
						<option value="-1">{!PINTERFACE_LEVEL_GLOBAL}</option>
					{+END}
					<optgroup label="{!PINTERFACE_PRESETS}">
						<option value="0">{!PINTERFACE_LEVEL_0}</option>
						<option value="1">{!PINTERFACE_LEVEL_1}</option>
						<option value="2">{!PINTERFACE_LEVEL_2}</option>
						<option value="3">{!PINTERFACE_LEVEL_3}</option>
					</optgroup>
				</select>
			</label>
		{+END}
	</th>

	<td class="form_table_field_input">
		<div class="accessibility_hidden"><label for="access_{GROUP_ID*}">{PINTERFACE_VIEW*} ({GROUP_NAME*})</label></div>

		<input tabindex="{TABINDEX*}" class="input_tick" type="checkbox" id="access_{GROUP_ID*}" name="access_{GROUP_ID*}" title="{PINTERFACE_VIEW*}" value="1"{+START,IF,{VIEW_ACCESS}} checked="checked"{+END} />

		{+START,IF,{$NOT,{ALL_GLOBAL}}}
			<script>// <![CDATA[
				var list=document.getElementById('access_{GROUP_ID;/}_presets');
				// Test to see what we wouldn't have to make a change to get - and that is what we're set at
				if (!copy_permission_presets('access_{GROUP_ID;/}','0',true)) list.selectedIndex=list.options.length-4;
				else if (!copy_permission_presets('access_{GROUP_ID;/}','1',true)) list.selectedIndex=list.options.length-3;
				else if (!copy_permission_presets('access_{GROUP_ID;/}','2',true)) list.selectedIndex=list.options.length-2;
				else if (!copy_permission_presets('access_{GROUP_ID;/}','3',true)) list.selectedIndex=list.options.length-1;
			//]]></script>
		{+END}
	</td>

	{OVERRIDES}

	{+START,IF,{$OR,{FORCE_PRESETS},{$IS_NON_EMPTY,{OVERRIDES}}}}
		{+START,IF,{$JS_ON}}
			<td class="form_table_field_input">
				<button class="buttons__copy button_screen_item button_micro_tall" type="button" id="copy_button_access_{GROUP_ID*}" onclick="permission_repeating(this,'access_{GROUP_ID%}'); return false;">{!REPEAT_PERMISSION}</button>
			</td>
		{+END}
	{+END}
</tr>
