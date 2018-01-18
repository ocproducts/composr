{$SET,rand,{$RAND}}

<div class="{$,xhtml-substr-no-break Enable if you do not want the grid-style layout }media-set" data-view="ComcodeMediaSet" data-view-params="{+START,PARAMS_JSON,rand,set_img_width_height,WIDTH,HEIGHT}{_*}{+END}" id="media_set_{$GET*,rand}">
	{$SET,raw_video,1}
	{MEDIA}
	{$SET,raw_video,0}
</div>
