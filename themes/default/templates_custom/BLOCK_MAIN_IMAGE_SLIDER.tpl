{$SET,rand,{$RAND}}

<script>
	$(document).ready(function() {
		$('#skitter_{$GET;/,rand}').skitter({
			auto_play: true,
			controls: true,
			dots: true,
			enable_navigation_keys: true,
			interval: {MILL%},
			numbers_align: 'center',
			preview: true,
			progressbar: false,
			theme: 'clean',
			thumbs: false
		});
	});
</script>

<div class="box_skitter" style="width: {WIDTH*}px; height: {HEIGHT*}px;" id="skitter_{$GET*,rand}">
	<ul>
		{+START,LOOP,IMAGES}
			<li>
				<a href="#slider_{_loop_key*}"><img src="{$THUMBNAIL*,{FULL_URL},{WIDTH}x{HEIGHT},,,,pad,both}" class="{TRANSITION_TYPE*}" /></a>
				<div class="label_text">{$PARAGRAPH,{TITLE}}</div>
			</li>
		{+END}
	</ul>
</div>
