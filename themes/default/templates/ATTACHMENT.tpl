{+START,IF,{$NOT,{$BROWSER_MATCHES,simplified_attachments_ui}}}
<div class="wide_table_wrap" data-view-core-rich-media="Attachment" data-view-args="{+START,PARAMS_JSON,I,POSTING_FIELD_NAME,FILTER,SYNDICATION_JSON,NO_QUOTA}{_*}{+END}">
	<table class="map_table form_table wide_table">
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
							<input size="15" type="file" id="file{I*}" name="file{I*}" class="js-inp-file-attachment" />
						</span>

						{+START,IF_PASSED,SYNDICATION_JSON}
							<div id="file{I*}_syndication_options" class="syndication_options"></div>
						{+END}
					</div>
				</td>
			</tr>
		</tbody>
	</table>
</div>
{+END}
