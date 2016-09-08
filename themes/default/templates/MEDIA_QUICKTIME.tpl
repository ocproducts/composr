{$SET,player_id,player_{$RAND}}

<div data-tpl-core-rich-media="mediaQuicktime" data-tpl-args="{+START,PARAMS_JSON,player_id}{_*}{+END}">
{+START,IF_PASSED_AND_TRUE,FRAMED}
<figure>
{+END}
	{+START,IF_NON_PASSED_OR_FALSE,WYSIWYG_EDITABLE}
		{+START,IF_EMPTY,{$METADATA,video}}
			{$METADATA,video,{URL}}
			{$METADATA,video:height,{HEIGHT}}
			{$METADATA,video:width,{WIDTH}}
			{$METADATA,video:type,{MIME_TYPE}}
		{+END}
	{+END}

	<div class="webstandards_checker_off">
		<object style="display: none" id="qt_event_source_{$GET*,player_id}" classid="clsid:CB927D12-4FF7-4a9e-A169-56E4B8A75598" codebase="http://www.apple.com/qtactivex/qtplugin.cab#version=7,2,1,0"></object>
		<embed id="{$GET*,player_id}" style="behavior:url(#qt_event_source_{$GET*,player_id});" name="{$GET*,player_id}" type="video/quicktime"
			src="{$ENSURE_PROTOCOL_SUITABILITY*,{URL}}"
			autoplay="false"
			enablejavascript="true"
			postdomevents="true"
			controller="true"
			pluginspage="http://www.apple.com/quicktime/download/"
			scale="ASPECT"
			width="{WIDTH*}"
			height="{$ADD,{HEIGHT*},16}"
		></embed>
	</div>

	{+START,IF_NON_EMPTY,{DESCRIPTION}}
		<figcaption class="associated_details">
			{$PARAGRAPH,{DESCRIPTION}}
		</figcaption>
	{+END}

	{$,Uncomment for a download link \{+START,INCLUDE,MEDIA__DOWNLOAD_LINK\}\{+END\}}

{+START,IF_PASSED_AND_TRUE,FRAMED}
</figure>
{+END}
</div>