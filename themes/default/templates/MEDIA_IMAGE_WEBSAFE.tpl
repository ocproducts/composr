{+START,IF_NON_PASSED_OR_FALSE,WYSIWYG_EDITABLE}
	{+START,IF,{$OR,{$IN_STR,{$META_DATA,image},/icons/},{$IS_EMPTY,{$META_DATA,image}}}}
		{$META_DATA,image,{THUMB_URL}}
	{+END}
{+END}

{+START,IF_PASSED_AND_TRUE,FRAMED}
	<figure class="attachment">
		<figcaption>{!IMAGE}</figcaption>
		<div>
			{+START,IF_NON_EMPTY,{DESCRIPTION}}
				{$,Extra div needed to stop WYSIWYG editor making a mess}
				<div{+START,IF,{$NEQ,{WIDTH}x{HEIGHT},{$CONFIG_OPTION,thumb_width}x{$CONFIG_OPTION,thumb_width}}} style="width: {$MAX*,{WIDTH},80}px"{+END}>
					{$PARAGRAPH,{DESCRIPTION}}
				</div>
			{+END}

			<div class="attachment_details">
				<a
					{+START,IF,{$NOT,{$INLINE_STATS}}}onclick="return ga_track(this,'{!IMAGE;*}','{FILENAME;*}');"{+END}
					target="_blank"
					title="{+START,IF_NON_EMPTY,{DESCRIPTION}}{DESCRIPTION*} {+END}{!LINK_NEW_WINDOW}"
					{+START,IF_PASSED,CLICK_URL}href="{CLICK_URL*}"{+END}
					{+START,IF_NON_PASSED,CLICK_URL}
						rel="lightbox"
						href="{URL*}"
					{+END}
				><img
					{+START,IF,{$NEQ,{WIDTH}x{HEIGHT},{$CONFIG_OPTION,thumb_width}x{$CONFIG_OPTION,thumb_width}}}
						{+START,IF_NON_EMPTY,{WIDTH}}width="{WIDTH*}"{+END}
						{+START,IF_NON_EMPTY,{HEIGHT}}height="{HEIGHT*}"{+END}
					{+END}
					alt=""
					src="{$ENSURE_PROTOCOL_SUITABILITY*,{THUMB_URL}}"
					{+START,IF_PASSED,URL_SAFE}{+START,IF_NON_EMPTY,{WIDTH}}srcset="{$THUMBNAIL*,{URL_SAFE},{$MULT,{WIDTH},2}} 2x"{+END}{+END}
				/></a>

				{$,Uncomment for a download link \{+START,INCLUDE,MEDIA__DOWNLOAD_LINK\}\{+END\}}

				{+START,IF_NON_PASSED,CLICK_URL}<p class="associated_details">({!CLICK_TO_ENLARGE})</p>{+END}
			</div>
		</div>
	</figure>
{+END}
{+START,IF_NON_PASSED_OR_FALSE,FRAMED}
	{+START,IF_PASSED,CLICK_URL}{+START,IF,{$NOT,{THUMB}}}<a href="{CLICK_URL*}">{+END}{+END}{+START,IF,{THUMB}}<a
		target="_blank"
		title="{+START,IF_NON_EMPTY,{DESCRIPTION}}{DESCRIPTION*} {+END}{!LINK_NEW_WINDOW}"
		{+START,IF_PASSED,CLICK_URL}href="{CLICK_URL*}"{+END}
		{+START,IF_NON_PASSED,CLICK_URL}
			rel="lightbox"
			href="{URL*}"
		{+END}
	>{+END}<img
		{+START,IF,{$NEQ,{WIDTH}x{HEIGHT},{$CONFIG_OPTION,thumb_width}x{$CONFIG_OPTION,thumb_width}}}
			{+START,IF_NON_EMPTY,{WIDTH}}width="{WIDTH*}"{+END}
			{+START,IF_NON_EMPTY,{HEIGHT}}height="{HEIGHT*}"{+END}
		{+END}

		{+START,IF_NON_PASSED_OR_FALSE,WYSIWYG_EDITABLE}
			{+START,IF,{THUMB}}
				{+START,IF_PASSED,NUM_DOWNLOADS}
					alt="{!IMAGE_ATTACHMENT,{$NUMBER_FORMAT*,{NUM_DOWNLOADS}},{CLEAN_FILESIZE*}}"
				{+END}
				{+START,IF_NON_PASSED,NUM_DOWNLOADS}
					alt="{DESCRIPTION*}"
				{+END}
			{+END}

			{+START,IF,{$NOT,{THUMB}}}
				alt="{DESCRIPTION*}"
			{+END}
		{+END}

		{+START,IF_PASSED_AND_TRUE,WYSIWYG_EDITABLE}
			alt="{DESCRIPTION*}"
		{+END}

		class="attachment_img"
		src="{$ENSURE_PROTOCOL_SUITABILITY*,{THUMB_URL}}"
		{+START,IF_PASSED,URL_SAFE}{+START,IF_NON_EMPTY,{WIDTH}}srcset="{$THUMBNAIL*,{URL_SAFE},{$MULT,{WIDTH},2}} 2x"{+END}{+END}
	/>{+START,IF,{THUMB}}</a>{+END}{+START,IF_PASSED,CLICK_URL}{+START,IF,{$NOT,{THUMB}}}</a>{+END}{+END}
{+END}
