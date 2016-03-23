<div>
	{+START,IF_PASSED,USERNAME}{+START,IF_PASSED,MEMBER_ID}
		<div class="toggleable_tray_title">
			{!OVERRIDES_FOR_FRIEND,{USERNAME*}}
			<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode);"><img alt="{$?,{HAS_SOME},{!CONTRACT},{!EXPAND}}" title="{$?,{HAS_SOME},{!CONTRACT},{!EXPAND}}" src="{$IMG*,1x/trays/{$?,{HAS_SOME},contract,expand}}" srcset="{$IMG*,2x/trays/{$?,{HAS_SOME},contract,expand}} 2x" /></a>
		</div>
	{+END}{+END}

	<div{+START,IF_PASSED,MEMBER_ID} class="toggleable_tray" id="user_{MEMBER_ID*}"{+START,IF,{$NOT,{HAS_SOME}}} style="{$JS_ON,display: none,}{+END}"{+END} aria-expanded="false">
		<div class="wide_table_wrap"><table class="map_table form_table wide_table scrollable_inside">
			{+START,IF,{$NOT,{$MOBILE}}}
				<colgroup>
					<col class="field_name_column" />
					<col class="field_input_column" />
				</colgroup>
			{+END}

			<tbody>
				{+START,LOOP,EFFECTS}
					<tr class="form_table_field_spacer">
						<th{+START,IF,{$NOT,{$MOBILE}}} colspan="2"{+END}  class="table_heading_cell">
							<span class="faux_h2">{EFFECT_TITLE*}</span>
						</th>
					</tr>

					<tr class="field_input">
						<th id="form_table_field_name__select_{KEY*}{+START,IF_PASSED,MEMBER_ID}_{MEMBER_ID*}{+END}" class="form_table_field_name">
							<label for="select_{KEY*}{+START,IF_PASSED,MEMBER_ID}_{MEMBER_ID*}{+END}"><span class="form_field_name field_name">{!BROWSE}</span></label>
						</th>

						{+START,IF,{$MOBILE}}
							</tr>

							<tr class="field_input">
						{+END}

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

							<input class="button_screen_item menu__social__chat__sound" type="button" onclick="var ob=document.getElementById('select_{KEY;*}{+START,IF_PASSED,MEMBER_ID}_{MEMBER_ID*}{+END}'); var val=ob.options[ob.selectedIndex].value; if (val=='') window.fauxmodal_alert('{!PLEASE_SELECT_SOUND;}'); else play_sound_url(val); return false;" title="{EFFECT_TITLE*}" value="{!TEST_SOUND}" />
						</td>
					</tr>

					<tr class="field_input">
						<th id="form_table_field_name__upload_{KEY*}{+START,IF_PASSED,MEMBER_ID}_{MEMBER_ID*}{+END}" class="form_table_field_name">
							<span class="form_field_name field_name">{!ALT_FIELD,{!UPLOAD}}</span>
						</th>

						{+START,IF,{$MOBILE}}
							</tr>

							<tr class="field_input">
						{+END}

						<td id="form_table_field_input__upload_{KEY*}{+START,IF_PASSED,MEMBER_ID}_{MEMBER_ID*}{+END}" class="form_table_field_input">
							<div class="upload_field">
								<label class="accessibility_hidden" for="upload_{KEY*}{+START,IF_PASSED,MEMBER_ID}_{MEMBER_ID*}{+END}">{!ALT_FIELD,{!UPLOAD}}</label>
								<input name="upload_{KEY*}{+START,IF_PASSED,MEMBER_ID}_{MEMBER_ID*}{+END}" id="upload_{KEY*}{+START,IF_PASSED,MEMBER_ID}_{MEMBER_ID*}{+END}" type="file" />

								<input type="hidden" name="clear_button_upload_{KEY*}{+START,IF_PASSED,MEMBER_ID}_{MEMBER_ID*}{+END}" id="clear_button_upload_{KEY*}{+START,IF_PASSED,MEMBER_ID}_{MEMBER_ID*}{+END}" />
								{+START,IF,{$NOT,{$IS_HTTPAUTH_LOGIN}}}
									<script>// <![CDATA[
										add_event_listener_abstract(window,'load',function() {
											preinit_file_input('chat_effect_settings','upload_{KEY;/}{+START,IF_PASSED,MEMBER_ID}_{MEMBER_ID;/}{+END}',null,null,'mp3','button_micro');
										});
									//]]></script>
								{+END}
							</div>
						</td>
					</tr>
				{+END}
			</tbody>
		</table></div>
	</div>
</div>
