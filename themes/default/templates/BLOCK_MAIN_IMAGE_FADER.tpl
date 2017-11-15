{$REQUIRE_JAVASCRIPT,galleries}

{$SET,RAND_FADER_IMAGE,{$RAND}}

{+START,IF,{$EQ,{BLOCK_ID},small_version}}
	<div class="box box___block_main_image_fader" data-view="BlockMainImageFader" data-view-params="{+START,PARAMS_JSON,RAND_FADER_IMAGE,MILL,TITLES,HTML,IMAGES}{_*}{+END}" data-keep-fix="{TITLES}{HTML}{IMAGES}{MILL}">
		<div class="box_inner">
			<h2>{!MEDIA}</h2>

			<div class="img_thumb_wrap">
				<a href="{GALLERY_URL*}"><img class="img_thumb" id="image_fader_{$GET%,RAND_FADER_IMAGE}" src="{$ENSURE_PROTOCOL_SUITABILITY*,{FIRST_URL}}" alt="" /></a>
			</div>
		</div>
	</div>
{+END}
{+START,IF,{$NEQ,{BLOCK_ID},small_version}}
	<div class="gallery_tease_pic_wrap" data-view="BlockMainImageFader" data-view-params="{+START,PARAMS_JSON,RAND_FADER_IMAGE,MILL,TITLES,HTML,IMAGES}{_*}{+END}" data-keep-fix="{TITLES}{HTML}{IMAGES}{MILL}">
		<div class="gallery_tease_pic">
		<div class="box box___gallery_tease_pic"><div class="box_inner">
			<div class="float_surrounder">
				<div class="gallery_tease_pic_pic">
					<div class="img_thumb_wrap">
						<a href="{GALLERY_URL*}"><img class="img_thumb" id="image_fader_{$GET%,RAND_FADER_IMAGE}" src="{$ENSURE_PROTOCOL_SUITABILITY*,{FIRST_URL}}" alt="" /></a>
					</div>
				</div>

				<h2 id="image_fader_title_{$GET%,RAND_FADER_IMAGE}">{!MEDIA}</h2>

				<div class="gallery_tease_pic_teaser" id="image_fader_scrolling_text_{$GET%,RAND_FADER_IMAGE}">
					<span aria-busy="true"><img alt="" src="{$IMG*,loading}" /></span>
				</div>
			</div>
		</div></div>
	</div>
	</div>
{+END}