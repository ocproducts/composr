{+START,SET,media}
	<embed src="{$ENSURE_PROTOCOL_SUITABILITY*,{URL}}" type="image/svg+xml" width="{WIDTH*}" height="{HEIGHT*}"></embed>

	{+START,IF_NON_PASSED_OR_FALSE,FRAMED}
		{+START,IF_NON_EMPTY,{DESCRIPTION}}
			<figcaption class="associated_details">
				{$PARAGRAPH,{DESCRIPTION}}
			</figcaption>
		{+END}
	{+END}
{+END}
{+START,IF_PASSED_AND_TRUE,FRAMED}
	<figure class="attachment">
		<figcaption>{!IMAGE}</figcaption>
		<div>
			{$PARAGRAPH,{DESCRIPTION}}

			<div class="attachment_details">
				<a{+START,IF,{$NOT,{$INLINE_STATS}}} onclick="return ga_track(this,'{!IMAGE;*}','{FILENAME;*}');"{+END} rel="lightbox" target="_blank" title="{+START,IF_NON_EMPTY,{DESCRIPTION}}{DESCRIPTION*}: {+END}{!LINK_NEW_WINDOW}" href="{URL*}">{$TRIM,{$GET,media}}</a>

				{$,Uncomment for a download link \{+START,INCLUDE,MEDIA__DOWNLOAD_LINK\}\{+END\}}
			</div>
		</div>
	</figure>
{+END}
{+START,IF_NON_PASSED_OR_FALSE,FRAMED}
	{$GET,media}
{+END}
