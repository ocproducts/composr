{$REQUIRE_JAVASCRIPT,core_form_interfaces}

<div aria-busy="true" class="spaced" id="loading-space" data-tpl="blockHelperDone" data-tpl-params="{+START,PARAMS_JSON,FIELD_NAME,COMCODE,COMCODE_SEMIHTML,SAVE_TO_ID,DELETE,PREFIX,sync_wysiwyg_attachments,TAG_CONTENTS}{_*}{+END}">
	<div class="ajax-loading vertical-alignment">
		<img width="20" height="20" src="{$IMG*,loading}" title="{!LOADING}" alt="{!LOADING}" />
		<span>{!LOADING}</span>
	</div>
</div>
