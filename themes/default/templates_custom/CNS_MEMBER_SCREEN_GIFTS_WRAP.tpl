<div data-toggleable-tray="{}">
	<h2 class="js-tray-header">
		<a class="toggleable_tray_button js-btn-tray-toggle" href="#!"><img alt="{!EXPAND}: {!GIFTR_TITLE}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand}" srcset="{$IMG*,2x/trays/expand} 2x" /></a>
		<span class="js-btn-tray-toggle">{!GIFTR_TITLE}</span>
	</h2>

	{$REQUIRE_CSS,gifts}

	<div class="toggleable_tray js-tray-content" style="display: none" aria-expanded="false">
		{+START,LOOP,GIFTS}
			<div class="box box___cns_member_screen_gifts_wrap"><div class="box_inner">
				<div class="float_surrounder">
					{+START,IF_NON_EMPTY,{IMAGE_URL}}
						<img src="{$THUMBNAIL*,{IMAGE_URL},50}" class="left float_separation" />
					{+END}

					{GIFT_EXPLANATION}
				</div>
			</div></div>
		{+END}

		{+START,IF_EMPTY,{GIFTS}}
			<p class="nothing_here">
				<span class="cns_member_detailer_titler">{!NO_ENTRIES}</span>
			</p>
		{+END}
	</div>
</div>
