{$REQUIRE_JAVASCRIPT,core_rich_media}
{$REQUIRE_JAVASCRIPT,core_notifications}
{$REQUIRE_JAVASCRIPT,checking}
{$REQUIRE_JAVASCRIPT,galleries}
{$REQUIRE_JAVASCRIPT,mediaelement-and-player}

<div class="gallery-nav" data-view="GalleryNav" data-view-params="{+START,PARAMS_JSON,_X,_N,SLIDESHOW}{_*}{+END}">
	{+START,IF,{SLIDESHOW}}
		<label for="slideshow_from" class="slideshow-speed">
			{!SPEED_IN_SECS}
			<input type="number" name="slideshow_from" class="form-control js-change-reset-slideshow-countdown js-mousedown-stop-slideshow-timer" id="slideshow_from" value="5" />
		</label>
		<input type="hidden" id="next_slide" name="next_slide" value="{SLIDESHOW_NEXT_URL*}" />
		<input type="hidden" id="previous_slide" name="previous_slide" value="{SLIDESHOW_PREVIOUS_URL*}" />
	{+END}

	<div class="gallery-nav-inner {+START,IF,{SLIDESHOW}}js-click-toggle-full-screen-or-slideshow-timer{+END}">
		{$,Back}
		{+START,IF_NON_EMPTY,{BACK_URL}}
		<a class="gallery-nav-prev-btn {+START,IF,{SLIDESHOW}}js-click-slideshow-backward{+END}"{+START,IF,{SLIDESHOW}} data-click-pd="1"{+END} rel="prev" accesskey="j" href="{BACK_URL*}">
			{+START,INCLUDE,ICON}NAME=buttons/previous{+END} 
			<span>{!PREVIOUS}</span>
			{BACK_THUMB}
		</a>
		{+END}

		<div class="gallery-nav-status">
			<span>
			{+START,IF,{SLIDESHOW}}
				<span class="must-show-together">{!VIEWING_SLIDE,{X*},{N*}}</span>

				{+START,IF_NON_EMPTY,{SLIDESHOW_NEXT_URL}}
					<span id="changer-wrap">{!CHANGING_IN,xxx}</span>
				{+END}

				{+START,IF_EMPTY,{NEXT_URL}}
					{!LAST_SLIDE}
				{+END}
			{+END}

			{+START,IF,{$NOT,{SLIDESHOW}}}
				<span class="must-show-together">{!GALLERY_MOBILE_PAGE_OF,{X*},{N*}}</span>
			{+END}
			</span>
		</div>

		{$,Start slideshow}
		{+START,IF_NON_EMPTY,{SLIDESHOW_URL}}{+START,IF,{$DESKTOP}}{+START,IF,{$NOT,{SLIDESHOW}}}
			<a class="btn btn-primary btn-scr buttons--slideshow desktop-only" rel="nofollow"{+START,IF,{$NOT,{$MOBILE}}} target="_blank" title="{!SLIDESHOW} {!LINK_NEW_WINDOW}"{+END} href="{SLIDESHOW_URL*}"><span>{+START,INCLUDE,ICON}NAME=buttons/slideshow{+END} {!_SLIDESHOW}</span></a>
		{+END}{+END}{+END}

		{$,Next}
		{+START,IF_NON_EMPTY,{NEXT_URL}}
		<a class="gallery-nav-next-btn {+START,IF,{SLIDESHOW}}js-click-slideshow-forward{+END}"{+START,IF,{SLIDESHOW}} data-click-pd="1"{+END} rel="next" accesskey="k" href="{NEXT_URL*}">
			{NEXT_THUMB}
			<span>{!NEXT}</span> 
			{+START,INCLUDE,ICON}NAME=buttons/next{+END}
		</a>
		{+END}
	</div>

	{$,Different positioning of slideshow button for mobiles, due to limited space}
	{+START,IF_NON_EMPTY,{SLIDESHOW_URL}} {+START,IF,{$NOT,{SLIDESHOW}}}
		<div class="clearfix mobile-only">
			<div class="right">
				<a class="btn btn-primary btn-scr buttons--slideshow" rel="nofollow"{+START,IF,{$NOT,{$MOBILE}}} target="_blank" title="{!SLIDESHOW} {!LINK_NEW_WINDOW}"{+END} href="{SLIDESHOW_URL*}"><span>{+START,INCLUDE,ICON}NAME=buttons/slideshow{+END} {!_SLIDESHOW}</span></a>
			</div>
		</div>
	{+END}{+END}
</div>
