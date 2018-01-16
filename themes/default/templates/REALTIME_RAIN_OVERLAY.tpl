{$REQUIRE_JAVASCRIPT,realtime_rain}

<div class="webstandards-checker-off" data-tpl="realtimeRainOverlay" data-tpl-params="{+START,PARAMS_JSON,MIN_TIME}{_*}{+END}">
	<div id="real-time-surround">
		<div id="real-time">
			<div id="news-ticker" class="js-hover-window-pause">
				<h1>{!NEWS_FLASHES}</h1>

				<div class="news-inside">
					<div class="news-content">
						<p id="news_go_here"><em>{!NEWS_WILL_APPEAR_HERE}</em></p>
					</div>
				</div>

				<div class="news-footer"></div>
			</div>

			<div id="bubbles_go_here">
			</div>

			<div id="loading-icon" class="ajax-loading"><img aria-busy="true" src="{$IMG*,loading}" alt="{!LOADING}" title="{!LOADING}" /></div>
		</div>

		<div id="timer-outer"><div id="timer-inner">
			<div id="real-time-indicator">
				<span id="real-time-date">{!LOADING}</span> <span id="real-time-time"></span>
			</div>

			<div id="timer">
				<div id="pause-but"><img class="js-click-toggle-window-pausing" src="{$IMG*,realtime_rain/pause-but}" alt="{!PAUSE}" title="{!PAUSE}" /></div>

				<div id="pre-but"><img class="js-click-rain-slow-down" src="{$IMG*,realtime_rain/pre}" alt="{!SLOW_DOWN}" title="{!SLOW_DOWN}" /></div>

				<div class="js-hover-toggle-real-time-indicator js-mouseover-set-time-line-position js-mousemove-timeline-click js-click-timeline-click" id="time-line">
					<img id="time-line-image" src="{$IMG*,realtime_rain/time-line}" alt="" />
				</div>

				<div id="next-but"><img class="js-click-rain-speed-up" src="{$IMG*,realtime_rain/next}" alt="{!SPEED_UP}" title="{!SPEED_UP}" /></div>
			</div>
		</div></div>
	</div>
</div>
