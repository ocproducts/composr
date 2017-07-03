{$REQUIRE_JAVASCRIPT,chat}

<div data-tpl="chatSetEffectsSettingBlock" data-tpl-params="{+START,PARAMS_JSON,KEY,MEMBER_ID}{_*}{+END}"{+START,IF_PASSED,MEMBER_ID} data-view="ToggleableTray"{+END}>
	{+START,IF_PASSED,USERNAME}{+START,IF_PASSED,MEMBER_ID}
		<div class="toggleable_tray_title js-tray-header">
			{!OVERRIDES_FOR_FRIEND,{USERNAME*}}
			<a class="toggleable_tray_button js-btn-tray-toggle" href="#!"><img alt="{$?,{HAS_SOME},{!CONTRACT},{!EXPAND}}" title="{$?,{HAS_SOME},{!CONTRACT},{!EXPAND}}" src="{$IMG*,1x/trays/{$?,{HAS_SOME},contract,expand}}" srcset="{$IMG*,2x/trays/{$?,{HAS_SOME},contract,expand}} 2x" /></a>
		</div>
	{+END}{+END}

	<div class="toggleable_tray js-tray-content"{+START,IF_PASSED,MEMBER_ID} id="user_{MEMBER_ID*}"{+END}{+START,IF,{$NOT,{HAS_SOME}}} style="display: none"{+END} aria-expanded="false">
		<div class="wide_table_wrap"><table class="map_table form_table wide_table scrollable_inside">
			{+START,IF,{$DESKTOP}}
				<colgroup>
					<col class="field_name_column" />
					<col class="field_input_column" />
				</colgroup>
			{+END}

			<tbody>
				{+START,LOOP,EFFECTS}
					<tr class="form_table_field_spacer">
						<th colspan="2" class="table_heading_cell">
							<span class="faux_h2">{EFFECT_TITLE*}</span>
						</th>
					</tr>

					<tr class="field_input">
						<th id="form_table_field_name__select_{KEY*}{+START,IF_PASSED,MEMBER_ID}_{MEMBER_ID*}{+END}" class="form_table_field_name">
							<label for="select_{KEY*}{+START,IF_PASSED,MEMBER_ID}_{MEMBER_ID*}{+END}"><span class="form_field_name field_name">{!BROWSE}</span></label>
						</th>

						<td id="form_table_field_input__select_{KEY*}{+START,IF_PASSED,MEMBER_ID}_{MEMBER_ID*}{+END}" class="form_table_field_input">
							<select name="select_{KEY*}{+START,IF_PASSED,MEMBER_ID}_{MEMBER_ID*}{+END}" id="select_{KEY*}{+START,IF_PASSED,MEMBER_ID}_{MEMBER_ID*}{+END}">
								{+START,IF_PASSED,USERNAME}
									<option{+START,IF,{$EQ,-1,{VALUE}}} selected="selected"{+END} value="-1">{$STRIP_TAGS,{!_UNSET}}</option>
								{+END}
								<option{+START,IF,{$EQ,,{VALUE}}} selected="selected"{+END} value="">{!NONE_EM}</option>
								{+START,LOOP,LIBRARY}
									<option{+START,IF,{$EQ,{EFFECT},{VALUE}}} selected="selected"{+END} value="{EFFECT*}">{EFFECT_SHORT*}</option>
								{+END}
								{+START,IF,{$EQ,{$SUBSTR,{VALUE},0,8},uploads/}}
									<option selected="selected" value="{VALUE*}">{!CUSTOM_UPLOAD}</option>
								{+END}
							</select>

							<input class="button_screen_item menu__social__chat__sound js-click-require-sound-selection" type="button" title="{EFFECT_TITLE*}" value="{!TEST_SOUND}" />
						</td>
					</tr>

					<tr class="field_input">
						<th id="form_table_field_name__upload_{KEY*}{+START,IF_PASSED,MEMBER_ID}_{MEMBER_ID*}{+END}" class="form_table_field_name">
							<span class="form_field_name field_name">{!ALT_FIELD,{!UPLOAD}}</span>
						</th>

						<td id="form_table_field_input__upload_{KEY*}{+START,IF_PASSED,MEMBER_ID}_{MEMBER_ID*}{+END}" class="form_table_field_input">
							<div class="upload_field">
								<label class="accessibility_hidden" for="upload_{KEY*}{+START,IF_PASSED,MEMBER_ID}_{MEMBER_ID*}{+END}">{!ALT_FIELD,{!UPLOAD}}</label>
								<input name="upload_{KEY*}{+START,IF_PASSED,MEMBER_ID}_{MEMBER_ID*}{+END}" id="upload_{KEY*}{+START,IF_PASSED,MEMBER_ID}_{MEMBER_ID*}{+END}" type="file" />

								<input type="hidden" name="clear_button_upload_{KEY*}{+START,IF_PASSED,MEMBER_ID}_{MEMBER_ID*}{+END}" id="clear_button_upload_{KEY*}{+START,IF_PASSED,MEMBER_ID}_{MEMBER_ID*}{+END}" />
							</div>
						</td>
					</tr>
				{+END}
			</tbody>
		</table></div>
	</div>
</div>
