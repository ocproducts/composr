{$REQUIRE_JAVASCRIPT,core_rich_media}
{$REQUIRE_CSS,carousels}

{$SET,carousel_id,{$RAND}}

<div class="xhtml_substr_no_break">
	<div id="carousel_{$GET*,carousel_id}" class="carousel" style="display: none" data-view-core-rich-media="Carousel" data-view-args="{+START,PARAMS_JSON,carousel_id}{_*}{+END}">
		<div class="move_left js-btn-car-move" data-move-amount="-50"></div>
		<div class="move_right js-btn-car-move" data-move-amount="+50"></div>

		<div class="main">
		</div>
	</div>

	<div class="carousel_temp" id="carousel_ns_{$GET*,carousel_id}">
		{+START,LOOP,TUTORIALS}
			<div style="display: inline-block">
				<a href="{URL*}" style="position: relative"><img src="{ICON*}" alt="" /><span style="position: absolute; bottom: 0; left: 0; padding: 0.3em 0.4em; color: white; background: black; background: rgba(0,0,0,0.6); font-size: 0.9em">{TITLE*}</span></a>
			</div>
		{+END}
	</div>
</div>
