{$REQUIRE_JAVASCRIPT,core_form_interfaces}
{$SET,sync_wysiwyg_attachments,0}

{$,WYSIWYG-editable attachments must be synched}
{+START,IF,{$EQ,{BLOCK},attachment_safe}}
{+START,IF,{$PREG_MATCH,^new_\d+$,{TAG_CONTENTS}}}
{$SET,sync_wysiwyg_attachments,1}
{+END}{+END}

<div aria-busy="true" class="spaced" id="loading_space" data-tpl="blockHelperDone" data-tpl-params="{+START,PARAMS_JSON,FIELD_NAME,COMCODE,COMCODE_SEMIHTML,SAVE_TO_ID,DELETE,PREFIX,sync_wysiwyg_attachments,TAG_CONTENTS}{_*}{+END}">
	<div class="ajax_loading vertical_alignment">
		<img id="loading_image" src="{$IMG*,loading}" title="{!LOADING}" alt="{!LOADING}" />
		<span>{!LOADING}</span>
	</div>
</div>
