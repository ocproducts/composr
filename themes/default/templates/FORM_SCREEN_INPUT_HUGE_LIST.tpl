<tr>
	{$SET,randomised_id,{$?,{$IS_EMPTY,{NAME*}},{$RAND},{NAME*}}}
	<th id="form_table_field_name__{$GET,randomised_id}"{+START,IF,{$NOT,{$MOBILE}}} colspan="2"{+END} class="form_table_description_above_cell{+START,IF,{REQUIRED}} required{+END}">
		<input type="hidden" name="label_for__{NAME*}" value="{$STRIP_TAGS,{PRETTY_NAME*}}" />

		<p class="field_name lonely_label">
			<label for="{NAME*}">{PRETTY_NAME*}:</label>
		</p>

		{+START,IF,{REQUIRED}}
			<span id="required_readable_marker__{$?,{$IS_EMPTY,{NAME*}},{$RAND},{NAME*}}" class="inline"><span class="required_star">*</span> <span class="accessibility_hidden">{!REQUIRED}</span></span>
		{+END}

		{+START,INCLUDE,FORM_SCREEN_FIELD_DESCRIPTION}{+END}
	</th>
</tr>

<tr class="field_input" data-tpl-core-form-interfaces="formScreenInputHugeList_input" data-tpl-args="{+START,PARAMS_JSON,INLINE_LIST,randomised_id}{_*}{+END}">
	<td id="form_table_field_input__{$GET,randomised_id}"{+START,IF,{$NOT,{$MOBILE}}} colspan="2"{+END} class="form_table_huge_field{+START,IF,{REQUIRED}} required{+END}">
		{+START,IF,{INLINE_LIST}}
		<select size="{+START,IF_PASSED,SIZE}{SIZE*}{+END}{+START,IF_NON_PASSED,SIZE}15{+END}" tabindex="{TABINDEX*}" class="input_list{REQUIRED*} wide_field" id="{NAME*}" name="{NAME*}">
		{+END}
		{+START,IF,{$NOT,{INLINE_LIST}}}
		<select tabindex="{TABINDEX*}" class="input_list" id="{NAME*}" name="{NAME*}" data-cms-select2='{"dropdownAutoWidth": true, "containerCssClass": "wide_field"}'>
		{+END}
		{CONTENT}
		</select>
	</td>
</tr>

