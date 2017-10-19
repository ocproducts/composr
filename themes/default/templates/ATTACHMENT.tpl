{+START,IF,{$NAND,{TRUE_ATTACHMENT_UI},{$BROWSER_MATCHES,simplified_attachments_ui}}}
	<div class="wide_table_wrap" data-view="Attachment" data-view-params="{+START,PARAMS_JSON,I,POSTING_FIELD_NAME,FILTER,SYNDICATION_JSON,NO_QUOTA}{_*}{+END}">
		<table class="map_table form_table wide_table">
			{+START,IF,{$DESKTOP}}
				<colgroup>
					<col class="attachments_field_name_column column_desktop" />
					<col class="attachments_field_input_column" />
				</colgroup>
			{+END}

			<tbody>
				<tr>
					{+START,IF,{$DESKTOP}}
						<th class="form_table_field_name vertical_alignment cell_desktop">
							{!ATTACHMENT,{I*}}

							{+START,IF,{TRUE_ATTACHMENT_UI}}
								<img class="help_icon" data-cms-rich-tooltip="{}" title="{!ATTACHMENT_HELP_2=,{$GET,IMAGE_TYPES}}" alt="{!HELP}" src="{$IMG*,icons/16x16/help}" srcset="{$IMG*,icons/32x32/help} 2x" />
							{+END}
						</th>
					{+END}
					<td class="form_table_field_input">
						<div class="upload_field">
							<div class="accessibility_hidden"><label for="file{I*}">{!UPLOAD}</label></div>

							<span class="vertical_alignment">
								<input size="15" type="file" id="file{I*}" name="file{I*}" class="js-inp-file-change-set-attachment" />
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
