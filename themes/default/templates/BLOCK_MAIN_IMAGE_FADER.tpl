{$SET,RAND_FADER_IMAGE,{$RAND}}

{+START,IF,{$EQ,{BLOCK_ID},small_version}}
	<div class="box box___block_main_image_fader"><div class="box_inner">
		<h2>{!MEDIA}</h2>

		<div class="img_thumb_wrap">
			<a href="{GALLERY_URL*}"><img class="img_thumb" id="image_fader_{$GET%,RAND_FADER_IMAGE}" src="{$ENSURE_PROTOCOL_SUITABILITY*,{FIRST_URL}}" alt="" /></a>
		</div>
	</div></div>
{+END}
{+START,IF,{$NEQ,{BLOCK_ID},small_version}}
	<div class="gallery_tease_pic_wrap"><div class="gallery_tease_pic">
		<div class="box box___gallery_tease_pic"><div class="box_inner">
			<div class="float_surrounder">
				<div class="gallery_tease_pic_pic">
					<div class="img_thumb_wrap">
						<a href="{GALLERY_URL*}"><img class="img_thumb" id="image_fader_{$GET%,RAND_FADER_IMAGE}" src="{$ENSURE_PROTOCOL_SUITABILITY*,{FIRST_URL}}" alt="" /></a>
					</div>
				</div>

				<h2 id="image_fader_title_{$GET%,RAND_FADER_IMAGE}">{!MEDIA}</h2>

				<div class="gallery_tease_pic_teaser" id="image_fader_scrolling_text_{$GET%,RAND_FADER_IMAGE}">
					<span aria-busy="true"><img id="loading_image" alt="" src="{$IMG*,loading}" /></span>
				</div>
			</div>
		</div></div>
	</div></div>
{+END}

<noscript>
	{+START,LOOP,HTML}
		{_loop_var}
	{+END}
</noscript>

<script>// <![CDATA[
	add_event_listener_abstract(window,'load',function() {
		var data={};
		initialise_image_fader(data,'{$GET%,RAND_FADER_IMAGE}');

		{+START,LOOP,TITLES}
			initialise_image_fader_title(data,'{_loop_var;^/}',{_loop_key%});
		{+END}
		{+START,LOOP,HTML}
			initialise_image_fader_html(data,'{_loop_var;^/}',{_loop_key%});
		{+END}
		{+START,LOOP,IMAGES}
			initialise_image_fader_image(data,'{$ENSURE_PROTOCOL_SUITABILITY;^/,{_loop_var}}',{_loop_key%},{MILL%},{IMAGES%});
		{+END}
	});
//]]></script>
