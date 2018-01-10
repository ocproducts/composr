{$SET,player_id,player_{$RAND}}
<div data-tpl="mediaRealmedia" data-tpl-params="{+START,PARAMS_JSON,player_id}{_*}{+END}">
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

		<div class="webstandards-checker-off">
			<embed id="{$GET*,player_id}" name="{$GET*,player_id}" type="audio/x-pn-realaudio"
				src="{$ENSURE_PROTOCOL_SUITABILITY*,{URL}}"
				autostart="false"
				controls="ImageWindow,ControlPanel"
				pluginspage="http://www.real.com"
				width="{WIDTH*}"
				height="{HEIGHT*}"
			></embed>
		</div>

		{+START,IF_NON_EMPTY,{DESCRIPTION}}
			<figcaption class="associated-details">
				{$PARAGRAPH,{DESCRIPTION}}
			</figcaption>
		{+END}

		{$,Uncomment for a download link \{+START,INCLUDE,MEDIA__DOWNLOAD_LINK\}\{+END\}}

	{+START,IF_PASSED_AND_TRUE,FRAMED}
		</figure>
	{+END}
</div>
