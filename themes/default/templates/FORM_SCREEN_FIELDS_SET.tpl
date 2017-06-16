<fieldset id="set_wrapper_{SET_NAME*}" data-tpl="formScreenFieldsSet" data-tpl-params="{+START,PARAMS_JSON,SET_NAME,REQUIRED}{_*}{+END}" class="innocuous_fieldset{+START,IF_PASSED,EXISTING_IMAGE_PREVIEW_URL}{+START,IF_NON_EMPTY,{EXISTING_IMAGE_PREVIEW_URL}} has_preview{+END}{+END}">
	<legend class="accessibility_hidden">{PRETTY_NAME*}</legend>

	{+START,IF_PASSED,EXISTING_IMAGE_PREVIEW_URL}{+START,IF_NON_EMPTY,{EXISTING_IMAGE_PREVIEW_URL}}
		<div class="preview">
			<img title="{!CURRENT}: {!PREVIEW}" alt="{!EXISTING}: {!PREVIEW}" src="{EXISTING_IMAGE_PREVIEW_URL*}" />
		</div>
	{+END}{+END}

	{FIELDS}
</fieldset>
