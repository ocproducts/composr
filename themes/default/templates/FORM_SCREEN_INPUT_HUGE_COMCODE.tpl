{$REQUIRE_JAVASCRIPT,core_form_interfaces}

{$, Template uses auto-complete}
{$REQUIRE_JAVASCRIPT,jquery}
{$REQUIRE_JAVASCRIPT,jquery_autocomplete}
{$REQUIRE_CSS,autocomplete}

<tr>
	{$SET,randomised_id,{$?,{$IS_EMPTY,{NAME*}},{$RAND},{NAME*}}}
	<th id="form_table_field_name__{$GET,randomised_id}" colspan="2" class="form-table-description-above-cell{+START,IF,{REQUIRED}} required{+END}">
		<input type="hidden" name="label_for__{NAME*}" value="{$STRIP_TAGS,{PRETTY_NAME*}}" />

		{COMCODE}

		<p class="field-name lonely-label">
			<label for="{NAME*}">{PRETTY_NAME*}<span class="inline_desktop">:</span></label>
		</p>

		<span id="required_readable_marker__{$?,{$IS_EMPTY,{NAME*}},{$RAND},{NAME*}}" style="display: {$?,{REQUIRED*},inline,none}"><span class="required-star">*</span> <span class="accessibility_hidden">{!REQUIRED}</span></span>

		{+START,INCLUDE,FORM_SCREEN_FIELD_DESCRIPTION}LEFT=1{+END}
	</th>
</tr>

<tr class="field-input">
	<td id="form_table_field_input__{$GET,randomised_id}" colspan="2" class="form-table-huge-field{+START,IF,{REQUIRED}} required{+END}">
		<div id="container_for_{NAME*}" class="container-for-wysiwyg">
			<textarea data-textarea-auto-height="" tabindex="{TABINDEX*}" class="input-text{_REQUIRED} wide-field{+START,IF,{SCROLLS}} textarea_scroll{+END}" cols="70" rows="{ROWS*}" id="{NAME*}" name="{NAME*}">{DEFAULT*}</textarea>

			{+START,IF_PASSED,DEFAULT_PARSED}
				<textarea aria-hidden="true" cols="1" rows="1" style="display: none" readonly="readonly" disabled="disabled" name="{NAME*}_parsed">{DEFAULT_PARSED*}</textarea>
			{+END}
		</div>

		<div class="tpl_placeholder" style="display: none;" data-require-javascript="core_form_interfaces" data-tpl="formScreenInputHugeComcode" data-tpl-params="{+START,PARAMS_JSON,REQUIRED,NAME,randomised_id,REQUIRED}{_*}{+END}"></div>
	</td>
</tr>
