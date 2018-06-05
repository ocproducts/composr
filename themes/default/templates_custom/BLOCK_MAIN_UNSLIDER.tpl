{$REQUIRE_JAVASCRIPT,jquery}
{$REQUIRE_JAVASCRIPT,unslider}

{+START,IF_NON_EMPTY,{WIDTH}}<div style="width: {WIDTH*}">{+END}
	<div id="{SLIDER_ID*}" class="unslider{+START,IF_EMPTY,{WIDTH}{HEIGHT}} responsive{+END}"{+START,IF_NON_EMPTY,{HEIGHT}} style="height: {HEIGHT*}"{+END}>
		<ul>
			{+START,LOOP,BGCOLORS}
				<li{+START,IF_NON_EMPTY,{_loop_var}} style="background-color: #{_loop_var%}"{+END}>
					{$TRIM,{$LOAD_PAGE,_unslider_{_loop_key}}}
				</li>
			{+END}
		</ul>
	</div>
{+START,IF_NON_EMPTY,{WIDTH}}</div>{+END}

<script>// <![CDATA[
	add_event_listener_abstract(window,'load',function() {
		var sliders=$('#{SLIDER_ID;/}');
		sliders.unslider({
			fluid: {$?,{FLUID},true,false},
			dots: {$?,{BUTTONS},true,false},
			delay: {$?,{$IS_EMPTY,{DELAY}},false,{DELAY%}},
			{+START,IF_NON_EMPTY,{HEIGHT}}balanceheight: false,{+END}
			speed: {SPEED%}
		});
		sliders.on('swipeleft', function(e) {
		    sliders.prev();
		}).on('swiperight', function(e) {
		    sliders.next();
		});
	});
//]]></script>
