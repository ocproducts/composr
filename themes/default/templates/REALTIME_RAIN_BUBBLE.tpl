{$REQUIRE_JAVASCRIPT,realtime_rain}
<div class="webstandards_checker_off" data-tpl="realtimeRainBubble" data-tpl-args="{+START,PARAMS_JSON,TICKER_TEXT,RELATIVE_TIMESTAMP,GROUP_ID,SPECIAL_ICON,MULTIPLICITY}{_*}{+END}">
	{$SET,RAND_ID,bubble_id_{$RAND}}

	<div id="{$GET,RAND_ID}" class="bubble_wrap attitude_{TYPE%}{$?,{IS_POSITIVE},_positive,}{$?,{IS_NEGATIVE},_negative,}">
		<div id="{$GET,RAND_ID}_main" class="bubble bubble_{TYPE%}">
			<div class="float_surrounder">
				<div class="email_icon">
					{+START,IF_PASSED,SPECIAL_ICON}
						<img src="{$IMG*,realtime_rain/{SPECIAL_ICON}}" alt="{SPECIAL_TOOLTIP*}" title="{SPECIAL_TOOLTIP*}" />
					{+END}
				</div>

				<div class="avatar_icon">
					{+START,IF_NON_EMPTY,{IMAGE}}
						<img src="{IMAGE*}" alt="" />
					{+END}
				</div>
			</div>

			<h1>{TITLE*}</h1>

			<div class="linkage">
				{+START,IF_PASSED,URL}
					<a href="{URL*}">{!VIEW}</a>
				{+END}
			</div>
		</div>
	</div>
</div>
