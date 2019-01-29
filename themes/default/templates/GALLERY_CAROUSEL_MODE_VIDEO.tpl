<div class="gallery-carousel-mode-entry is-video" itemscope="itemscope" itemtype="http://schema.org/VideoObject">
	<div class="media-box">
		{VIDEO_PLAYER}
	</div>

	{+START,IF_NON_EMPTY,{_TITLE}}
	<h2 class="entry-title">{+START,FRACTIONAL_EDITABLE,{_TITLE},title,_SEARCH:cms_galleries:__edit_other:{ID},1,1,{$HAS_EDIT_PERMISSION,mid,{SUBMITTER},{$MEMBER},cms_galleries,galleries,{CAT}}}{_TITLE*}{+END}</h2>
	{+END}

	{+START,IF_PASSED,DESCRIPTION}
		<div class="entry-description" itemprop="caption">
			{$PARAGRAPH,{DESCRIPTION}}
		</div>
	{+END}

	<div class="clearfix lined-up-boxes">
		<div class="gallery-entry-details right">
			<section class="box box---gallery-carousel-mode-video"><div class="box-inner">
				<h3>{!DETAILS}</h3>

				<table class="map-table results-table">
					{+START,IF,{$DESKTOP}}
						<colgroup>
							<col class="gallery-entry-field-name-column" />
							<col class="gallery-entry-field-value-column" />
						</colgroup>
					{+END}

					<tbody>
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

						{$PREG_REPLACE,</(table|div|tbody|colgroup|col)>,,{$PREG_REPLACE,<(table|div|tbody|colgroup|col)[^>]*>,,{VIDEO_DETAILS}}}
					</tbody>
				</table>

				<ul class="horizontal-links with-icons associated-links-block-group">
					<li>
						<a href="{VIEW_URL*}">
							{+START,INCLUDE,ICON}
								NAME=feedback/comment
								ICON_SIZE=24
							{+END}{$COMMENT_COUNT,images,{ID}}
						</a>
					</li>
				</ul>

				{$,Load up the staff actions template to display staff actions uniformly (we relay our parameters to it)...}
				{+START,INCLUDE,STAFF_ACTIONS}
					1_URL={EDIT_URL*}
					1_TITLE={!EDIT_THIS_VIDEO}
					1_ICON=admin/edit_this
				{+END}
			</div></section>
		</div>

		<div class="ratings right">
			{RATING_DETAILS}
		</div>
	</div>
</div>

