<div itemscope="itemscope" itemtype="http://schema.org/ImageObject">
	<div class="media-box">
		<img src="{THUMB_URL*}" alt="{!IMAGE}" itemprop="contentURL" />
	</div>

	{+START,IF_PASSED,DESCRIPTION}
		<div itemprop="caption">
			{$PARAGRAPH,{DESCRIPTION}}
		</div>
	{+END}

	<div class="clearfix lined-up-boxes">
		<div class="gallery-entry-details right">
			<section class="box box---gallery-flow-mode-image"><div class="box-inner">
				<h3>{!DETAILS}</h3>

				<table class="map-table results-table">
					{+START,IF,{$DESKTOP}}
						<colgroup>
							<col class="gallery-entry-field-name-column" />
							<col class="gallery-entry-field-value-column" />
						</colgroup>
					{+END}

					<tbody>
						{+START,IF_NON_EMPTY,{_TITLE}}
							<tr>
								<th class="de-th metadata-title">{!TITLE}</th>
								<td>
									{+START,FRACTIONAL_EDITABLE,{_TITLE},title,_SEARCH:cms_galleries:__edit:{ID},1,1,{$HAS_EDIT_PERMISSION,mid,{SUBMITTER},{$MEMBER},cms_galleries,galleries,{CAT}}}{_TITLE*}{+END}
								</td>
							</tr>
						{+END}

						<tr>
							<th class="de-th metadata-title">{!ADDED}</th>
							<td>
								<time datetime="{$FROM_TIMESTAMP*,Y-m-d\TH:i:s\Z,{ADD_DATE_RAW}}" itemprop="datePublished">{$DATE_TIME*,{ADD_DATE_RAW}}</time>
							</td>
						</tr>

						<tr>
							<th class="de-th metadata-title">{!BY}</th>
							<td>
								<a rel="author" href="{$MEMBER_PROFILE_URL*,{SUBMITTER}}" itemprop="author">{$USERNAME*,{SUBMITTER},1}</a>

								{+START,INCLUDE,MEMBER_TOOLTIP}{+END}
							</td>
						</tr>

						{+START,IF_NON_EMPTY,{EDIT_DATE_RAW}}
							<tr>
								<th class="de-th metadata-title">{!EDITED}</th>
								<td>{$DATE_TIME*,{EDIT_DATE_RAW}}</td>
							</tr>
						{+END}

						{+START,IF,{$INLINE_STATS}}
							<tr>
								<th class="de-th metadata-title">{!COUNT_VIEWS}</th>
								<td>{VIEWS*}</td>
							</tr>
						{+END}
					</tbody>
				</table>

				<ul class="horizontal-links with-icons associated-links-block-group">
					{+START,IF,{$ADDON_INSTALLED,recommend}}
						<li>
							<a href="{$PAGE_LINK*,:recommend:browse:subject={!ECARD_FOR_YOU_SUBJECT}:page_title={!SEND_AS_ECARD}:s_message={!ECARD_FOR_YOU,{$SELF_URL},{FULL_URL},{$SITE_NAME}}}">
								{+START,INCLUDE,ICON}
									NAME=file_types/email_link
									SIZE=24
								{+END}{!SEND_AS_ECARD}
							</a>
						</li>
					{+END}
					<li>
						<a href="{VIEW_URL*}">
							{+START,INCLUDE,ICON}
								NAME=feedback/comment
								SIZE=24
							{+END}{$COMMENT_COUNT,images,{ID}}
						</a>
					</li>
				</ul>

				{$,Load up the staff actions template to display staff actions uniformly (we relay our parameters to it)...}
				{+START,INCLUDE,STAFF_ACTIONS}
					1_URL={EDIT_URL*}
					1_TITLE={!EDIT_IMAGE}
					1_ICON=admin/edit_this
				{+END}
			</div></section>
		</div>

		<div class="ratings right">
			{RATING_DETAILS}
		</div>
	</div>
</div>
