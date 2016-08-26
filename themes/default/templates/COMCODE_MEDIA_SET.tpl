{$SET,rand,{$RAND}}

<div class="{$,xhtml_substr_no_break Enable if you do not want the grid-style layout }media_set"
	 data-tpl-core-rich-media="comcodeMediaSet" data-tpl-args="{+START,PARAMS_JSON,rand,set_img_width_height,WIDTH,HEIGHT}{_*}{+END}">
	<div id="media_set_{$GET*,rand}">
		{$SET,raw_video,1}
		{MEDIA}
		{$SET,raw_video,0}
	</div>
</div>