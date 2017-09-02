{$REQUIRE_JAVASCRIPT,core_form_interfaces}
<div aria-busy="true" class="spaced" id="loading_space" data-tpl="blockHelperDone" data-tpl-params="{+START,PARAMS_JSON,FIELD_NAME,COMCODE,COMCODE_SEMIHTML,SAVE_TO_ID,DELETE,PREFIX,sync_wysiwyg_attachments,TAG_CONTENTS}{_*}{+END}">
	<div class="ajax_loading vertical_alignment">
		<img src="{$IMG*,loading}" title="{!LOADING}" alt="{!LOADING}" />
		<span>{!LOADING}</span>
	</div>
</div>
