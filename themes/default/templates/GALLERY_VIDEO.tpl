<div class="gallery-grid-item is-video">
	<div class="img-thumb-wrap{+START,IF,{$HAS_DELETE_PERMISSION,mid,{SUBMITTER},{$MEMBER},cms_galleries}} img-thumb-opaque{+END}" {+START,IF,{$INLINE_STATS}}data-mouseover-activate-tooltip="['{VIEWS;^*} {!COUNT_VIEWS;^*}','auto',null,null,false,true]"{+END}>
		{+START,IF,{$HAS_DELETE_PERMISSION,mid,{SUBMITTER},{$MEMBER},cms_galleries}}
			{+START,INCLUDE,MASS_SELECT_MARKER}
				TYPE={MEDIA_TYPE}
				ID={ID}
			{+END}
		{+END}

		<a href="{VIEW_URL*}">{$TRIM,{THUMB}}</a>
	</div>

	{+START,IF_PASSED,RATING_DETAILS}{+START,IF_NON_EMPTY,{RATING_DETAILS}}
	<div class="grating">{RATING_DETAILS}</div>
	{+END}{+END}

	<h3 class="gallery-grid-item-heading">
		<a href="{VIEW_URL*}" class="subtle-link">{+START,FRACTIONAL_EDITABLE,{TITLE},title,_SEARCH:cms_galleries:__edit_other:{ID},1,1,{$HAS_EDIT_PERMISSION,mid,{SUBMITTER},{$MEMBER},cms_galleries,galleries,{CAT}}}{$TRUNCATE_LEFT,{TITLE},23,0,0}{+END}</a>
	</h3>

	<div class="gallery-grid-item-details">
		<ul class="horizontal-links">
			<li>
				{+START,INCLUDE,MEMBER_TOOLTIP}SUBMITTER={SUBMITTER}{+END}
				<a rel="author" href="{$MEMBER_PROFILE_URL*,{SUBMITTER}}">{$USERNAME*,{SUBMITTER},1}</a>
			</li>
			<li><a href="{VIEW_URL*}" title="{$DATE_TIME*,{ADD_DATE_RAW}}" class="subtle-link">{$FROM_TIMESTAMP,%e %b %Y,{ADD_DATE_RAW*}}</a></li>
			<li><a href="{VIEW_URL*}" class="subtle-link">{$COMMENT_COUNT,videos,{ID}}</a></li>
		</ul>
	</div>
</div>

