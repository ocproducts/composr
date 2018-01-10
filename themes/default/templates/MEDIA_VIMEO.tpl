{$SET,player_id,player_{$RAND}}
<div data-tpl="mediaVimeo" data-tpl-params="{+START,PARAMS_JSON,player_id,REMOTE_ID}{_*}{+END}">
	<div class="webstandards-checker-off">
		<iframe id="{$GET*,player_id}" src="https://player.vimeo.com/video/{REMOTE_ID*}?api=1"{+START,IF,{$_GET,slideshow}} autoplay="1"{+END} width="{WIDTH*}" height="{HEIGHT*}" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>
	</div>

	{+START,IF_NON_EMPTY,{DESCRIPTION}}
		<figcaption class="associated-details">
			{$PARAGRAPH,{DESCRIPTION}}
		</figcaption>
	{+END}
</div>
