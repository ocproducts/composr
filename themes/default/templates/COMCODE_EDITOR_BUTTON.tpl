{$REQUIRE_JAVASCRIPT,core_rich_media}
{+START,IF,{$NAND,{$MATCH_KEY_MATCH,_WILD:admin_zones},{$EQ,{B},code,quote,url}}}
<input data-tpl="comcodeEditorButton" data-tpl-params="{+START,PARAMS_JSON,IS_POSTING_FIELD,B,FIELD_NAME}{_*}{+END}" type="image"{+START,IF,{$AND,{$BROWSER_MATCHES,simplified_attachments_ui},{IS_POSTING_FIELD},{$EQ,{B},thumb,img}}} id="attachment_upload_button"{+END} class="comcode_button_{B*}{+START,IF,{DIVIDER}} divider{+END}" data-click-pd="1" title="{TITLE*}" alt="{TITLE*}" src="{$IMG*,comcodeeditor/{B}}" />
{+END}