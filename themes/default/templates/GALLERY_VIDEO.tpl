{+START,SET,TOOLTIP}
	<div class="gallery-tooltip">
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
					<td>{$DATE_TIME*,{ADD_DATE_RAW}}</td>
				</tr>

				<tr>
					<th class="de-th metadata-title">{!BY}</th>
					<td><a rel="author" href="{$MEMBER_PROFILE_URL*,{SUBMITTER}}">{$USERNAME*,{SUBMITTER},1}</a></td>
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

				{$SET,rating,{$RATING,videos,{ID},1,{SUBMITTER}}}
				{+START,IF_NON_EMPTY,{$TRIM,{$GET,rating}}}
					<tr>
						<th class="de-th metadata-title">{!RATING}</th>
						<td>{$GET,rating}</td>
					</tr>
				{+END}

				{$PREG_REPLACE,</(table|div|tbody|colgroup|col)>,,{$PREG_REPLACE,<(table|div|tbody|colgroup|col)[^>]*>,,{VIDEO_DETAILS}}}
			</tbody>
		</table>
	</div>
{+END}

{+START,IF,{$EQ,{_GUID},carousel}}
	<a data-mouseover-activate-tooltip="['{$GET;^*,TOOLTIP}','auto',null,null,false,true]" href="{VIEW_URL*}"><img height="140" src="{$THUMBNAIL*,{THUMB_URL},140x140,website_specific,vid{ID}.jpg,,height}" /></a>
{+END}

{+START,IF,{$NEQ,{_GUID},carousel}}
	<div class="gallery-regular-thumb">
		<div class="img-thumb-wrap{+START,IF,{$HAS_DELETE_PERMISSION,mid,{SUBMITTER},{$MEMBER},cms_galleries}} img-thumb-opaque{+END}" data-mouseover-activate-tooltip="['{$GET;^*,TOOLTIP}','auto',null,null,false,true]">
			{+START,IF,{$HAS_DELETE_PERMISSION,mid,{SUBMITTER},{$MEMBER},cms_galleries}}
				{+START,INCLUDE,MASS_SELECT_MARKER}
					TYPE={MEDIA_TYPE}
					ID={ID}
				{+END}
			{+END}

			<a href="{VIEW_URL*}">{$TRIM,{THUMB}}</a>
		</div>

		<p class="gallery-media-title-cropped">
			{+START,FRACTIONAL_EDITABLE,{TITLE},title,_SEARCH:cms_galleries:__edit_other:{ID},1,1,{$HAS_EDIT_PERMISSION,mid,{SUBMITTER},{$MEMBER},cms_galleries,galleries,{CAT}}}{$TRUNCATE_LEFT,{TITLE},23,0,0}{+END}
		</p>

		{+START,IF_PASSED,RATING_DETAILS}{+START,IF_NON_EMPTY,{RATING_DETAILS}}
			<div class="grating">{RATING_DETAILS}</div>
		{+END}{+END}
		<p class="gallery-regular-thumb-comments-count">
			{+START,IF_PASSED_AND_TRUE,COMMENT_COUNT}
				<a href="{VIEW_URL*}">{$COMMENT_COUNT,videos,{ID}}</a>
			{+END}
			{+START,IF_NON_PASSED_OR_FALSE,COMMENT_COUNT}
				<a href="{VIEW_URL*}">{!VIEW}</a>
			{+END}
		</p>
	</div>
{+END}
