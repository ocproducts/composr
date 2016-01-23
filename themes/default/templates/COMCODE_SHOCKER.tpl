{$SET,RAND_ID_SHOCKER,rand{$RAND}}

{$REQUIRE_JAVASCRIPT,dyn_comcode}
{$REQUIRE_JAVASCRIPT,pulse}

<div class="shocker">
	<div class="shocker_left" id="comcodeshocker{$GET,RAND_ID_SHOCKER}_left"></div>
	<div class="shocker_right" id="comcodeshocker{$GET,RAND_ID_SHOCKER}_right"></div>
</div>

<script>// <![CDATA[
	if (typeof window.shocker_parts=='undefined')
	{
		window.shocker_parts={};
		window.shocker_pos={};
	}
	window.shocker_parts['{$GET,RAND_ID_SHOCKER}']=[{+START,LOOP,PARTS}['{LEFT;^/}','{RIGHT;^/}'],{+END}''];
	window.shocker_pos['{$GET,RAND_ID_SHOCKER}']=0;
	add_event_listener_abstract(window,'load',function() {
		shocker_tick('{$GET,RAND_ID_SHOCKER}',{TIME%},'{MAX_COLOR;/}','{MIN_COLOR;/}');
		window.setInterval(function() { shocker_tick('{$GET,RAND_ID_SHOCKER}',{TIME%},'{MAX_COLOR;/}','{MIN_COLOR;/}'); },{TIME%});
	});
//]]></script>

<noscript>
	{FULL*}
</noscript>

