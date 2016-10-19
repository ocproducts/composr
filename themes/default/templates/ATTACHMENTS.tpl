{$REQUIRE_JAVASCRIPT,core_rich_media}
{$SET,IMAGE_TYPES,{IMAGE_TYPES}}
{$SET,SIMPLE_UI,{$BROWSER_MATCHES,simplified_attachments_ui}}

<div data-tpl="attachments" data-tpl-params="{+START,PARAMS_JSON,SIMPLE_UI,ATTACHMENT_TEMPLATE,POSTING_FIELD_NAME,MAX_ATTACHMENTS,FILTER,POSTING_FIELD_NAME}{_*}{+END}">
{+START,IF,{$BROWSER_MATCHES,simplified_attachments_ui}}
	<div id="attachment_store" class="accessibility_hidden">
		{$,plupload will attach upload code to here}
	</div>

	<div id="attachment_progress_bars">
		<div id="fsUploadProgress" class="progressBars">
		</div>
	</div>
{+END}

{+START,IF,{$NOT,{$BROWSER_MATCHES,simplified_attachments_ui}}}
	{+START,IF,{$ADDON_INSTALLED,filedump}}{+START,IF,{$HAS_ACTUAL_PAGE_ACCESS,filedump}}{+START,IF,{$EQ,{$ZONE},cms}}
		<p>
			{!ADD_ATTACHMENTS_MEDIA_LIBRARY,{POSTING_FIELD_NAME;*}}
		</p>
	{+END}{+END}{+END}

	<div id="attachment_store">
		{ATTACHMENTS}
	</div>

	{+START,IF_NON_EMPTY,{$_GET,id}}
		<p>
			{!comcode:DELETE_ATTACHMENTS,<a class="js-click-open-attachment-popup" rel="nofollow" title="{!comcode:ATTACHMENT_POPUP} {!LINK_NEW_WINDOW}" target="_blank" href="{$FIND_SCRIPT*,attachment_popup}?field_name={POSTING_FIELD_NAME*}{$KEEP*,0,1}">{!comcode:ATTACHMENT_POPUP}</a>}
		</p>
	{+END}
{+END}
</div>