<div class="upload-field inline_block multi_field" data-tpl="formScreenInputUploadMulti" data-tpl-params="{+START,PARAMS_JSON,SYNDICATION_JSON,PLUPLOAD,NAME_STUB,I,FILTER}{_*}{+END}">
	<div class="accessibility_hidden"><label for="{NAME_STUB*}_{I*}">{!UPLOAD}</label></div>
	<div class="vertical_alignment inline_block">
		<input tabindex="{TABINDEX*}" class="input-upload{REQUIRED*} js-input-change-ensure-next-field-upload" type="file" id="{NAME_STUB*}_{I*}" name="{NAME_STUB*}_{I*}" />

		<input type="hidden" name="label_for_{NAME_STUB*}_{I*}" value="{!UPLOAD}" />

		{+START,IF_NON_EMPTY,{EDIT}}
			{$, If you want to let people remove all in one tick
			<p class="upload-field-msg inline_block">
				<input type="checkbox" id="i_{NAME*}_unlink" name="{NAME_STUB*}_unlink" value="1" />
				<label for="i_{NAME_STUB*}_unlink">
					{!UNLINK_EXISTING_UPLOADS}
				</label>
			</p>
			}

			{+START,LOOP,EDIT}
				<p class="upload-field-msg inline_block">
					<input type="checkbox" id="i_{NAME_STUB*}_{$ADD*,{_loop_key},1}_unlink" name="{NAME_STUB*}_{$ADD*,{_loop_key},1}_unlink" value="1" />
					<label for="i_{NAME_STUB*}_{$ADD*,{_loop_key},1}_unlink">
						{!UNLINK_EXISTING_UPLOAD_SPECIFIC,<kbd>{$URLDECODE*,{$PREG_REPLACE,.*/,,{_loop_var}}}</kbd>}
					</label>
				</p>
			{+END}
		{+END}

		<input class="button-micro buttons--clear js-click-clear-name-stub-input" type="button" id="clear_button_{NAME_STUB*}_{I*}" value="{!CLEAR}" />

		<!--Additional uploaders will auto-append here-->
	</div>

	{+START,IF_PASSED,SYNDICATION_JSON}
		<div id="{NAME_STUB*}_syndication_options" class="syndication-options"></div>
	{+END}
</div>
