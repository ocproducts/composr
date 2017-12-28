{$REQUIRE_JAVASCRIPT,core_form_interfaces}

{+START,IF,{$AND,{IS_IMAGE},{$IS_NON_EMPTY,{EXISTING_URL}}}}
	<img class="upload-field-image-preview" src="{$ENSURE_PROTOCOL_SUITABILITY*,{EXISTING_URL}}" title="" alt="{!EXISTING;^}" />
{+END}

<div class="upload-field inline_block" data-require-javascript="core_form_interfaces" data-view="FromScreenInputUpload" data-view-params="{+START,PARAMS_JSON,NAME,PLUPLOAD,FILTER,SYNDICATION_JSON}{_*}{+END}">
	<div class="vertical_alignment inline_block">
		<input tabindex="{TABINDEX*}" class="input_upload{REQUIRED*}" type="file" id="{NAME*}" name="{NAME*}" />
		{+START,IF,{EDIT}}
			<p class="upload-field-msg inline_block">
				<input type="checkbox" id="i_{NAME*}_unlink" name="{NAME*}_unlink" value="1" />
				<label for="i_{NAME*}_unlink">
					{+START,IF,{$NOT,{$AND,{IS_IMAGE},{$IS_NON_EMPTY,{EXISTING_URL}}}}}
						{!UNLINK_EXISTING_UPLOAD}
					{+END}
					{+START,IF,{$AND,{IS_IMAGE},{$IS_NON_EMPTY,{EXISTING_URL}}}}
						{!UNLINK_EXISTING_UPLOAD_IMAGE,{$GET*,image_preview}}
					{+END}
				</label>
			</p>
		{+END}
	</div>

	{+START,IF_PASSED,SYNDICATION_JSON}
		<div id="{NAME*}_syndication_options" class="syndication-options"></div>
	{+END}
</div>
