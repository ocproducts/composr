{$REQUIRE_JAVASCRIPT,workflows}
{$SET,early_description,1}

<div data-require-javascript="workflows" data-tpl="formScreenInputVariousTicks" data-tpl-params="{+START,PARAMS_JSON,CUSTOM_ACCEPT_MULTIPLE,CUSTOM_NAME}{_*}{+END}" data-view="ToggleableTray">
	{+START,IF_PASSED,EXPANDED}
		<h4 class="comcode_quote_h4 js-tray-header">
			<a class="toggleable_tray_button js-btn-tray-toggle" href="#!">
				<img alt="{!EXPAND}/{!CONTRACT}" src="{$IMG*,1x/trays/{$?,{EXPANDED},contract,expand}}" srcset="{$IMG*,2x/trays/{$?,{EXPANDED},contract,expand}} 2x" />
			</a>

			<a class="toggleable_tray_button js-btn-tray-toggle" href="#!">{SECTION_TITLE*}</a>
		</h4>

		<div class="toggleable_tray js-tray-content" style="display: {$?,{EXPANDED},block,none}"{+START,IF,{$NOT,{EXPANDED}}} aria-expanded="false"{+END}>
	{+END}

	{+START,IF,{$NOT,{SIMPLE_STYLE}}}
		<div class="various_ticks float_surrounder">
			{+START,LOOP,OUT}
				<div class="input_individual_tick">
					<label for="i_{NAME*}"><input title="{DESCRIPTION*}" tabindex="{TABINDEX*}" class="input_tick"{+START,IF,{CHECKED}} checked="checked"{+END} type="checkbox" id="i_{NAME*}" name="{NAME*}" value="1"{+START,IF,{DISABLED}} disabled="disabled"{+END} /> {PRETTY_NAME*}</label>
					<input type="hidden" name="label_for__{NAME*}" value="{$STRIP_TAGS,{PRETTY_NAME*}}" />
					<input name="tick_on_form__{NAME*}" value="0" type="hidden" />
				</div>
			{+END}
		</div>
	{+END}
	{+START,IF,{SIMPLE_STYLE}}
		{+START,LOOP,OUT}
			<p>
				<label for="i_{NAME*}"><input title="{DESCRIPTION*}" tabindex="{TABINDEX*}" class="input_tick"{+START,IF,{CHECKED}} checked="checked"{+END} type="checkbox" id="i_{NAME*}" name="{NAME*}" value="1" /> {PRETTY_NAME*}</label>
				<input type="hidden" name="label_for__{NAME*}" value="{$STRIP_TAGS,{PRETTY_NAME*}}" />
				<input name="tick_on_form__{NAME*}" value="0" type="hidden" />
			</p>
		{+END}
	{+END}

	{+START,IF_PASSED,CUSTOM_NAME}
		<div class="input_other_tick">
			{+START,IF,{CUSTOM_ACCEPT_MULTIPLE}}
				{+START,LOOP,CUSTOM_VALUE}
					<div><div>
						{+START,IF,{$EQ,{_loop_key},0}}
							<label for="{CUSTOM_NAME*}_value_{_loop_key*}">{!OTHER}</label>&hellip;<br />
						{+END}
						<input id="{CUSTOM_NAME*}_value_{_loop_key*}" class="js-keypress-ensure-next-field" name="{CUSTOM_NAME*}_value[]" value="{_loop_var*}" size="15" type="text" value="" />
					</div></div>
				{+END}
			{+END}

			{+START,IF,{$NOT,{CUSTOM_ACCEPT_MULTIPLE}}}
				<div><div>
					<input value="1" class="input_tick js-click-value-input-toggle-disabled" id="{CUSTOM_NAME*}" name="{CUSTOM_NAME*}" type="checkbox" />
					<label for="{CUSTOM_NAME*}">{!OTHER}</label> <label for="{CUSTOM_NAME*}_value"><span class="associated_details">({!PLEASE_STATE})</span></label>
					<input id="{CUSTOM_NAME*}_value" class="js-change-value-checkbox-toggle-checked" name="{CUSTOM_NAME*}_value"
						value="{+START,IF_PASSED,CUSTOM_VALUE}{CUSTOM_VALUE*}{+END}" size="15" type="text" />
				</div></div>
			{+END}
		</div>
	{+END}

	{+START,IF_PASSED,EXPANDED}
		</div>
	{+END}
</div>
