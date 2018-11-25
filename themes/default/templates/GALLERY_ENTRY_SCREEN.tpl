{$REQUIRE_JAVASCRIPT,jquery}

<div class="gallery-entry-screen" id="gallery-entry-screen" itemscope="itemscope" itemtype="http://schema.org/{+START,IF_PASSED,VIDEO}Video{+END}{+START,IF_NON_PASSED,VIDEO}Image{+END}Object">
	{TITLE}

	{+START,IF,{$NOT,{SLIDESHOW}}}
		{WARNING_DETAILS}
	{+END}

	{NAV}

	{+START,SET,boxes}
		<div class="gallery-entry-details right">
			<table class="columned-table map-table results-table" role="note">
				{+START,IF,{$DESKTOP}}
					<colgroup>
						<col class="gallery-entry-field-name-column" />
						<col class="gallery-entry-field-value-column" />
					</colgroup>
				{+END}

				<thead>
					<tr>
						<th colspan="2">
							{!DETAILS}
						</th>
					</tr>
				</thead>

				<tbody>
					<tr>
						<th class="de-th metadata-title">{!ADDED}</th>
						<td>
							<time datetime="{$FROM_TIMESTAMP*,Y-m-d\TH:i:s\Z,{ADD_DATE_RAW}}" itemprop="datePublished">{ADD_DATE*}</time>
						</td>
					</tr>

					<tr>
						<th class="de-th metadata-title">{!BY}</th>
						<td>
							<a rel="author" href="{$MEMBER_PROFILE_URL*,{SUBMITTER}}" itemprop="author">{$USERNAME*,{SUBMITTER},1}</a>

							{+START,INCLUDE,MEMBER_TOOLTIP}{+END}
						</td>
					</tr>

					{+START,IF_NON_EMPTY,{RATING_DETAILS}}
						{$SET,rating,{$RATING,{MEDIA_TYPE},{ID},{SUBMITTER},,,RATING_INLINE_DYNAMIC}}
						{+START,IF_NON_EMPTY,{$TRIM,{$GET,rating}}}
							<tr>
								<th class="de-th metadata-title">{!RATING}</th>
								<td>{$GET,rating}</td>
							</tr>
						{+END}
					{+END}

					{+START,IF_NON_EMPTY,{EDIT_DATE}}
						<tr>
							<th class="de-th metadata-title">{!EDITED}</th>
							<td>{EDIT_DATE*}</td>
						</tr>
					{+END}

					{+START,IF,{$INLINE_STATS}}
						<tr>
							<th class="de-th metadata-title">{!COUNT_VIEWS}</th>
							<td>{VIEWS*}</td>
						</tr>
					{+END}

					{+START,IF_NON_EMPTY,{$REVIEW_STATUS,{MEDIA_TYPE},{ID}}}
						<tr>
							<td colspan="2">
								{$REVIEW_STATUS,{MEDIA_TYPE},{ID}}
							</td>
						</tr>
					{+END}
				</tbody>
			</table>

			{+START,IF,{$ADDON_INSTALLED,recommend}}{+START,IF,{$CONFIG_OPTION,enable_ecards}}
				{+START,IF_NON_PASSED,VIDEO}
					<p class="associated-link vertical-alignment">
						<a href="{$PAGE_LINK*,:recommend:browse:subject={!ECARD_FOR_YOU_SUBJECT}:page_title={!SEND_AS_ECARD}:s_message={!ECARD_FOR_YOU,{$SELF_URL},{URL*},{$SITE_NAME}}:ecard=1}">
							{+START,INCLUDE,ICON}NAME=file_types/email_link{+END}{!SEND_AS_ECARD}
						</a>
					</p>
				{+END}
			{+END}{+END}
		</div>

		{+START,IF_NON_EMPTY,{MEMBER_DETAILS}}{+START,IF_PASSED,MEMBER_ID}
			<div class="gallery-member-details right">
				<div class="box box---gallery-entry-screen"><div class="box-inner">
					<h2>{GALLERY_TITLE*}</h2>

					{MEMBER_DETAILS}
				</div></div>
			</div>
		{+END}{+END}

		{+START,IF_NON_EMPTY,{TRACKBACK_DETAILS}}
			<div class="trackbacks right">
				{TRACKBACK_DETAILS}
			</div>
		{+END}
	{+END}

	<div class="media-box">
		{+START,IF_NON_PASSED,VIDEO}
			<img class="scale-down" alt="{!IMAGE}" src="{$ENSURE_PROTOCOL_SUITABILITY*,{URL}}" itemprop="contentURL" />
		{+END}
		{+START,IF_PASSED,VIDEO}
			{+START,IF,{$GT,{$METADATA,video:width},500}}
				{VIDEO}
			{+END}

			{$,If the video is not large, we will put the boxes right alongside it}
			{+START,IF,{$NOT,{$GT,{$METADATA,video:width},500}}}
				<div class="clearfix">
					<div class="lined-up-boxes">
						{$GET,boxes}
					</div>

					<div class="left">
						{VIDEO}
					</div>
				</div>
			{+END}

			<!-- <p><a href="{URL*}">{!TO_DOWNLOAD_VIDEO}</a></p> -->
		{+END}
	</div>

	{+START,IF,{SLIDESHOW}}
		{+START,IF_NON_EMPTY,{E_TITLE}{COMMENT_DETAILS}}
			<p itemprop="caption">
				{+START,IF_NON_EMPTY,{E_TITLE}}
					<strong>{E_TITLE*}</strong>
				{+END}

				{+START,IF_NON_EMPTY,{COMMENT_DETAILS}}
					{COMMENT_DETAILS}
				{+END}
			</p>
		{+END}
	{+END}

	{+START,IF,{$NOT,{SLIDESHOW}}}
		{+START,IF_NON_EMPTY,{DESCRIPTION}}
			<div itemprop="caption">
				{$PARAGRAPH,{DESCRIPTION}}
			</div>
		{+END}

		{+START,IF,{$OR,{$NEQ,{MEDIA_TYPE},video},{$GT,{$METADATA,video:width},500}}}
			<div class="clearfix lined-up-boxes">
				{$GET,boxes}
			</div>
		{+END}

		{$SET,bound_catalogue_entry,{$CATALOGUE_ENTRY_FOR,{MEDIA_TYPE},{ID}}}
		{+START,IF_NON_EMPTY,{$GET,bound_catalogue_entry}}{$CATALOGUE_ENTRY_ALL_FIELD_VALUES,{$GET,bound_catalogue_entry}}{+END}

		{+START,IF,{$THEME_OPTION,show_content_tagging}}{TAGS}{+END}

		{$,Load up the staff actions template to display staff actions uniformly (we relay our parameters to it)...}
		{+START,INCLUDE,STAFF_ACTIONS}
			1_URL={EDIT_URL*}
			1_TITLE={!EDIT}
			1_REL=edit
			1_ICON=admin/edit_this
			{+START,IF,{$ADDON_INSTALLED,tickets}}
				2_URL={$PAGE_LINK*,_SEARCH:report_content:content_type={MEDIA_TYPE}:content_id={ID}:redirect={$SELF_URL&}}
				2_TITLE={!report_content:REPORT_THIS}
				2_ICON=buttons/report
				2_REL=report
			{+END}
		{+END}

		<div class="content-screen-comments">
			{COMMENT_DETAILS}
		</div>
	{+END}

	{+START,IF,{$THEME_OPTION,show_screen_actions}}{$BLOCK,failsafe=1,block=main_screen_actions,title={$METADATA,title}}{+END}
<!--DO_NOT_REMOVE_THIS_COMMENT--></div>
