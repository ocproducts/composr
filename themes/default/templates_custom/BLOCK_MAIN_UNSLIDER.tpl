{$REQUIRE_JAVASCRIPT,jquery}
{$REQUIRE_JAVASCRIPT,unslider}

{+START,IF_NON_EMPTY,{WIDTH}}<div style="width: {WIDTH*}">{+END}
	<div id="{SLIDER_ID*}" class="unslider{+START,IF_EMPTY,{WIDTH}{HEIGHT}} responsive{+END}"{+START,IF_NON_EMPTY,{HEIGHT}} style="height: {HEIGHT*}"{+END} data-tpl="blockMainUnslider" data-tpl-params="{+START,PARAMS_JSON,SLIDER_ID,FLUID,BUTTONS,DELAY,HEIGHT,SPEED}{_*}{+END}">
		<ul>
			{+START,LOOP,BGCOLORS}
				<li{+START,IF_NON_EMPTY,{_loop_var}} style="background-color: #{_loop_var%}"{+END}>
					{$TRIM,{$LOAD_PAGE,_unslider_{_loop_key}}}
				</li>
			{+END}
		</ul>
	</div>
{+START,IF_NON_EMPTY,{WIDTH}}</div>{+END}
