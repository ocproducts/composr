{$REQUIRE_JAVASCRIPT,core_rich_media}
{$REQUIRE_CSS,carousels}

{$SET,carousel_id,{$RAND}}

<div class="xhtml-substr-no-break">
	<div id="carousel_{$GET*,carousel_id}" class="carousel" style="display: none" data-view="Carousel" data-view-params="{+START,PARAMS_JSON,carousel_id}{_*}{+END}">
		<div class="move-left js-btn-car-move" data-move-amount="-{SCROLL_AMOUNT%}"></div>
		<div class="move-right js-btn-car-move" data-move-amount="+{SCROLL_AMOUNT%}"></div>

		<div class="main">
		</div>
	</div>

	<div class="carousel-temp" id="carousel_ns_{$GET*,carousel_id}">
		{CONTENT}
	</div>
</div>
