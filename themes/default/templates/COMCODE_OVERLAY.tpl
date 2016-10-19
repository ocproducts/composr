{$REQUIRE_JAVASCRIPT,core_rich_media}
{$SET,RAND_ID_OVERLAY,overlay_{$RAND}}
<div role="dialog" class="comcode_overlay box" id="{$GET,RAND_ID_OVERLAY}" data-tpl="comcodeOverlay" data-tpl-params="{+START,PARAMS_JSON,ID,RAND_ID_OVERLAY,TIMEOUT,TIMEIN}{_*}{+END}"
	 style="display: none; position: absolute; left: {X*}px; top: {Y*}px; width: {WIDTH*}px; height: {HEIGHT*}px">
	<div class="comcode_overlay_inner box_inner">
		<div class="comcode_overlay_main">
			{EMBED}
		</div>

		<div class="comcode_overlay_dismiss">
			<p class="associated_link suggested_link">
				<a href="#!" class="js-click-dismiss-overlay">{!DISMISS}</a>
			</p>
		</div>
	</div>
</div>
