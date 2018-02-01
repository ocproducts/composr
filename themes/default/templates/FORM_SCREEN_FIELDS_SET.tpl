<fieldset id="set-wrapper-{SET_NAME*}" data-tpl="formScreenFieldsSet" data-tpl-params="{+START,PARAMS_JSON,SET_NAME,REQUIRED,DEFAULT_SET}{_*}{+END}" class="innocuous-fieldset{+START,IF_PASSED,EXISTING_IMAGE_PREVIEW_URL}{+START,IF_NON_EMPTY,{EXISTING_IMAGE_PREVIEW_URL}} has-preview{+END}{+END}">
	<legend class="accessibility-hidden">{PRETTY_NAME*}</legend>

	{+START,IF_PASSED,EXISTING_IMAGE_PREVIEW_URL}{+START,IF_NON_EMPTY,{EXISTING_IMAGE_PREVIEW_URL}}
		<div class="preview">
			<img title="{!CURRENT}: {!PREVIEW}" alt="{!EXISTING}: {!PREVIEW}" src="{EXISTING_IMAGE_PREVIEW_URL*}" />
		</div>
	{+END}{+END}

	{FIELDS}
</fieldset>
