<div class="gallery-mosaic-item is-video">
	<a class="gallery-mosaic-item-inner img-thumb-opaque" href="{VIEW_URL*}">
		{$TRIM,{THUMB}}
		<div class="gallery-mosaic-item-overlay">
			<div class="gallery-mosaic-item-overlay-top">
				{+START,IF_PASSED,RATING_DETAILS}{+START,IF_NON_EMPTY,{$TRIM,{RATING_DETAILS}}}
				<div class="left grating">{RATING_DETAILS}</div>
				{+END}{+END}

				<div class="right">
					<span class="views">{+START,INCLUDE,ICON}NAME=cns_topic_modifiers/hot{+END} {VIEWS;^*}</span>
					<span class="comments">{+START,INCLUDE,ICON}NAME=feedback/comment{+END} {$COMMENT_COUNT,images,{ID}}</span>
				</div>
			</div>

			<div class="gallery-mosaic-item-overlay-bottom">
				<div class="add-date">{$FROM_TIMESTAMP,%e %b %Y,{ADD_DATE_RAW*}}</div>
				<h3 class="title">{TITLE}</h3>
				<div class="submitter">{+START,INCLUDE,ICON}NAME=content_types/member{+END} {$USERNAME*,{SUBMITTER},1}</div>
			</div>
		</div>
	</a>
</div>
