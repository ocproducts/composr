{$REQUIRE_JAVASCRIPT,core_rich_media}
{$REQUIRE_JAVASCRIPT,core_notifications}
{$REQUIRE_JAVASCRIPT,checking}
{$REQUIRE_JAVASCRIPT,galleries}
{$REQUIRE_JAVASCRIPT,mediaelement-and-player}

<div data-view="GalleryNav" data-view-params="{+START,PARAMS_JSON,_X,_N,SLIDESHOW}{_*}{+END}">
	{+START,IF,{SLIDESHOW}}
		<label for="slideshow_from" class="slideshow_speed">
			{!SPEED_IN_SECS}
			<input type="number" name="slideshow_from" class="js-change-reset-slideshow-countdown js-mousedown-stop-slideshow-timer" id="slideshow_from" value="5" />
		</label>
		<input type="hidden" id="next_slide" name="next_slide" value="{SLIDESHOW_NEXT_URL*}" />
		<input type="hidden" id="previous_slide" name="previous_slide" value="{SLIDESHOW_PREVIOUS_URL*}" />
	{+END}

	<div class="trinav_wrap" id="gallery_nav">
		<div class="trinav_left">
			{$,Back}
			{+START,IF_NON_EMPTY,{BACK_URL}}
				<a class="button_screen buttons--previous {+START,IF,{SLIDESHOW}}js-click-slideshow-backward{+END}"{+START,IF,{SLIDESHOW}} data-click-pd="1"{+END} rel="prev" accesskey="j" href="{BACK_URL*}"><span>{!PREVIOUS}</span></a>
			{+END}
			{+START,IF_EMPTY,{BACK_URL}}
				<span class="button_screen buttons--previous-none"><span>{!PREVIOUS}</span></span>
			{+END}
		</div>

		<div class="trinav_right">
			{$,Start slideshow}
			{+START,IF_NON_EMPTY,{SLIDESHOW_URL}}
				{+START,IF,{$DESKTOP}}
					{+START,IF,{$NOT,{SLIDESHOW}}}
						<a class="button_screen buttons--slideshow inline_desktop" rel="nofollow"{+START,IF,{$NOT,{$MOBILE}}} target="_blank" title="{!SLIDESHOW} {!LINK_NEW_WINDOW}"{+END} href="{SLIDESHOW_URL*}"><span>{!_SLIDESHOW}</span></a>
					{+END}
				{+END}
			{+END}

			{$,Next}
			{+START,IF_NON_EMPTY,{NEXT_URL}}
				<a class="button_screen buttons--next {+START,IF,{SLIDESHOW}}js-click-slideshow-forward{+END}"{+START,IF,{SLIDESHOW}} data-click-pd="1"{+END} rel="next" accesskey="k" href="{NEXT_URL*}"><span>{!NEXT}</span></a>
			{+END}
			{+START,IF_EMPTY,{NEXT_URL}}
				<span class="button_screen buttons--next-none"><span>{!NEXT}</span></span>
			{+END}
		</div>

		<div class="trinav_mid text">
			<span>
			{+START,IF,{SLIDESHOW}}
				<span class="must_show_together">{!VIEWING_SLIDE,{X*},{N*}}</span>

				{+START,IF_NON_EMPTY,{SLIDESHOW_NEXT_URL}}
					<span id="changer_wrap">{!CHANGING_IN,xxx}</span>
				{+END}

				{+START,IF_EMPTY,{NEXT_URL}}
					{!LAST_SLIDE}
				{+END}
			{+END}

			{+START,IF,{$NOT,{SLIDESHOW}}}
				<span class="must_show_together">{!GALLERY_MOBILE_PAGE_OF,{X*},{N*}}</span>
			{+END}
			</span>
		</div>
	</div>

	{$,Different positioning of slideshow button for mobiles, due to limited space}
	{+START,IF_NON_EMPTY,{SLIDESHOW_URL}}
		{+START,IF,{$NOT,{SLIDESHOW}}}
			<div class="float-surrounder block_mobile">
				<div class="right block_mobile">
					<a class="button_screen buttons--slideshow" rel="nofollow"{+START,IF,{$NOT,{$MOBILE}}} target="_blank" title="{!SLIDESHOW} {!LINK_NEW_WINDOW}"{+END} href="{SLIDESHOW_URL*}"><span>{!_SLIDESHOW}</span></a>
				</div>
			</div>
		{+END}
	{+END}
</div>
