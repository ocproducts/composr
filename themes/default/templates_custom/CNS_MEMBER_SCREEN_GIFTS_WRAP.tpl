<div>
	<h2>
		<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode);"><img alt="{!EXPAND}: {!GIFTR_TITLE}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand}" srcset="{$IMG*,2x/trays/expand} 2x" /></a>
		<span onclick="/*Access-note: code has other activation*/ return toggleable_tray(this.parentNode.parentNode);">{!GIFTR_TITLE}</span>
	</h2>

	{$REQUIRE_CSS,gifts}

	<div class="toggleable_tray" style="display: {$JS_ON,none,block}" aria-expanded="false">
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
