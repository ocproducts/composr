<div class="webstandards_checker_off">
	<div id="real_time_surround">
		<div id="real_time">
			<div id="news_ticker" onmouseover="if (!window.paused) { this.pausing=true; window.paused=true; }" onmouseout="if (this.pausing) { this.pausing=false; window.paused=false; }">
				<h1>{!NEWS_FLASHES}</h1>

				<div class="news_inside">
					<div class="news_content">
						<p id="news_go_here"><em>{!NEWS_WILL_APPEAR_HERE}</em></p>
					</div>
				</div>

				<div class="news_footer"></div>
			</div>

			<div id="bubbles_go_here">
			</div>

			<div id="loading_icon" class="ajax_loading"><img aria-busy="true" src="{$IMG*,loading}" alt="{!LOADING}" title="{!LOADING}" /></div>
		</div>

		<div id="timer_outer"><div id="timer_inner">
			<div id="real_time_indicator">
				<span id="real_time_date">{!LOADING}</span> <span id="real_time_time"></span>
			</div>

			<div id="timer">
				<div id="pause_but"><img onclick="toggle_window_pausing(this);" src="{$IMG*,realtime_rain/pause-but}" alt="{!PAUSE}" title="{!PAUSE}" /></div>

				<div id="pre_but"><img onclick="window.time_window=window.time_window/1.2;" src="{$IMG*,realtime_rain/pre}" alt="{!SLOW_DOWN}" title="{!SLOW_DOWN}" /></div>

				<div onmouseover="window.disable_real_time_indicator=true;" onmouseout="window.disable_real_time_indicator=false; set_time_line_position(window.current_time);" onmousemove="timeline_click(this,true);" onclick="timeline_click(this);" id="time_line"><img id="time_line_image" src="{$IMG*,realtime_rain/time-line}" alt="" /></div>

				<div id="next_but"><img onclick="window.time_window=window.time_window*1.2;" src="{$IMG*,realtime_rain/next}" alt="{!SPEED_UP}" title="{!SPEED_UP}" /></div>
			</div>
		</div></div>
	</div>

	<script>// <![CDATA[
		add_event_listener_abstract(window,'load',function() {
			start_realtime_rain();
		});
		window.min_time={MIN_TIME%};
		window.paused=false;
		window.bubble_groups={};
		window.total_lines=0;
		window.bubble_timer_1=null;
		window.bubble_timer_2=null;
	//]]></script>
</div>
