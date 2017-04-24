{$SET,rand,{$RAND}}

<div class="box_skitter" style="width: {WIDTH*}px; height: {HEIGHT*}px;" id="skitter_{$GET*,rand}"
	 data-require-javascript="image_slider" data-tpl="blockMainImageSlider" data-tpl-params="{+START,PARAMS_JSON,rand,MILL}{_*}{+END}">
	<ul>
		{+START,LOOP,IMAGES}
			<li>
				<a href="#slider_{_loop_key*}"><img src="{$THUMBNAIL*,{FULL_URL},{WIDTH}x{HEIGHT},,,,pad,both}" class="{TRANSITION_TYPE*}" /></a>
				<div class="label_text">{$PARAGRAPH,{TITLE}}</div>
			</li>
		{+END}
	</ul>
</div>
