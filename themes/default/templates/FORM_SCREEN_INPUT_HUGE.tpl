{$SET,randomised_id,{$?,{$IS_EMPTY,{NAME*}},{$RAND},{NAME*}}}

<tr>
	<th id="form_table_field_name__{$GET,randomised_id}"{+START,IF,{$NOT,{$MOBILE}}} colspan="2"{+END} class="form_table_description_above_cell{+START,IF,{REQUIRED}} required{+END}">
		<input type="hidden" name="label_for__{NAME*}" value="{$STRIP_TAGS,{PRETTY_NAME*}}" />

		<p class="field_name lonely_label">
			<label for="{NAME*}">{PRETTY_NAME*}:</label>
		</p>

		<span id="required_readable_marker__{$?,{$IS_EMPTY,{NAME*}},{$RAND},{NAME*}}" style="display: {$?,{REQUIRED*},inline,none}"><span class="required_star">*</span> <span class="accessibility_hidden">{!REQUIRED}</span></span>

		{+START,INCLUDE,FORM_SCREEN_FIELD_DESCRIPTION}{+END}
	</th>
</tr>

<tr class="field_input" data-tpl="formScreenInputHuge_input" data-tpl-args="{+START,PARAMS_JSON,randomised_id,NAME}{_*}{+END}">
	<td id="form_table_field_input__{$GET,randomised_id}" {+START,IF,{$NOT,{$MOBILE}}} colspan="2"{+END} class="form_table_huge_field {+START,IF,{REQUIRED}} required{+END}">
		<div id="container_for_{NAME*}" class="constrain_field">
			<textarea tabindex="{TABINDEX*}" class="input_text{_REQUIRED} wide_field" {+START,IF,{SCROLLS}}wrap="off"{+END} cols="70" rows="{ROWS*}" id="{NAME*}" name="{NAME*}" {+START,IF,{$NOT,{$MOBILE}}} onchange="manage_scroll_height(this);" onkeyup="manage_scroll_height(this);"{+END}>{DEFAULT*}</textarea>

			{+START,IF_PASSED_AND_TRUE,RAW}<input type="hidden" name="pre_f_{NAME*}" value="1" />{+END}
		</div>
	</td>
</tr>

