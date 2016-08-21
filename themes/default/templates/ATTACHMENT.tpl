{+START,IF,{$NOT,{$BROWSER_MATCHES,simplified_attachments_ui}}}
	<div class="wide_table_wrap"><table class="map_table form_table wide_table">
		{+START,IF,{$NOT,{$MOBILE}}}
			<colgroup>
				{+START,IF,{$NOT,{$MOBILE}}}
					<col class="attachments_field_name_column" />
				{+END}
				<col class="attachments_field_input_column" />
			</colgroup>
		{+END}

		<tbody>
			<tr>
				{+START,IF,{$NOT,{$MOBILE}}}
					<th class="form_table_field_name vertical_alignment">
						{!ATTACHMENT,{I*}}

						{+START,IF,{$NOT,{$MOBILE}}}
							<img class="activate_rich_semantic_tooltip help_icon" onclick="this.onmouseover(event);" title="{!ATTACHMENT_HELP_2=,{$GET,IMAGE_TYPES}}" onmouseover="activate_rich_semantic_tooltip(this,event);" alt="{!HELP}" src="{$IMG*,icons/16x16/help}" srcset="{$IMG*,icons/32x32/help} 2x" />
						{+END}
					</th>
				{+END}
				<td class="form_table_field_input">
					<div class="upload_field">
						<div class="accessibility_hidden"><label for="file{I*}">{!UPLOAD}</label></div>

						<span class="vertical_alignment">
							<input size="15" type="file" onchange="set_attachment('post',{I*},'');" id="file{I*}" name="file{I*}"
								data-cms-call="preinit_file_input" data-cms-call-args='["attachment_multi", "file{I*#}", null, "{POSTING_FIELD_NAME*#}" {+START,IF_PASSED,FILTER},"{FILTER*#}"{+END}]'/>

							{+START,IF,{$AND,{$JS_ON},{$BROWSER_MATCHES,gecko}}}<input class="button_micro buttons__clear" type="button" id="clear_button_file{I*}" value="{!CLEAR}" onclick="return clear_attachment({I%},form.elements['post']);" title="{!CLEAR}: {!ATTACHMENT,{I*}}" />{+END}
						</span>

						{+START,IF_PASSED,SYNDICATION_JSON}
							<div id="file{I*}_syndication_options" class="syndication_options"
								 data-cms-call="show_upload_syndication_options" data-cms-call-args='["file{I*#}", "{SYNDICATION_JSON*#} {+START,IF_PASSED_AND_TRUE,NO_QUOTA}, true{+END}"]'></div>
						{+END}
					</div>
				</td>
			</tr>
		</tbody>
	</table></div>
{+END}
