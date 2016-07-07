{TITLE}

<div class="float_surrounder">
	<div class="calendar_top_navigation">
		<div class="calendar_date_span_link"><div class="calendar_date_span_link_inner">
			{+START,IF_NON_EMPTY,{YEAR_URL}}
				<a href="{YEAR_URL*}">{!YEARLY}</a>
			{+END}
			{+START,IF_EMPTY,{YEAR_URL}}
				<span>{!YEARLY}</span>
			{+END}
		</div></div>
		<div class="calendar_date_span_link"><div class="calendar_date_span_link_inner">
			{+START,IF_NON_EMPTY,{MONTH_URL}}
				<a href="{MONTH_URL*}">{!MONTHLY}</a>
			{+END}
			{+START,IF_EMPTY,{MONTH_URL}}
				<span>{!MONTHLY}</span>
			{+END}
		</div></div>
		<div class="calendar_date_span_link"><div class="calendar_date_span_link_inner">
			{+START,IF_NON_EMPTY,{WEEK_URL}}
				<a href="{WEEK_URL*}">{!WEEKLY}</a>
			{+END}
			{+START,IF_EMPTY,{WEEK_URL}}
				<span>{!WEEKLY}</span>
			{+END}
		</div></div>
		<div class="calendar_date_span_link"><div class="calendar_date_span_link_inner">
			{+START,IF_NON_EMPTY,{DAY_URL}}
				<a href="{DAY_URL*}">{!DAILY}</a>
			{+END}
			{+START,IF_EMPTY,{DAY_URL}}
				<span>{!DAILY}</span>
			{+END}
		</div></div>
	</div>
</div>

<div class="trinav_wrap nograd">
	<div class="trinav_left">
		<a class="button_screen buttons__previous" href="{PREVIOUS_URL*}" rel="{+START,IF,{PREVIOUS_NO_FOLLOW}}nofollow {+END}prev" accesskey="j"><span>{!PREVIOUS}</span></a>
	</div>
	<div class="trinav_right">
		<a class="button_screen buttons__next" href="{NEXT_URL*}" rel="{+START,IF,{NEXT_NO_FOLLOW}}nofollow {+END}next" accesskey="k"><span>{!NEXT}</span></a>
	</div>
	{+START,IF,{$NOT,{$MOBILE}}}
		<div class="trinav_mid">
			{+START,IF_NON_EMPTY,{ADD_URL}}
				<a class="button_screen menu___generic_admin__add_one" rel="add" href="{ADD_URL*}"><span>{!ADD_CALENDAR_EVENT}</span></a>
			{+END}
		</div>
	{+END}
</div>

<div class="horizontal_scrolling">
	{MAIN}
</div>

{+START,IF_NON_EMPTY,{ADD_URL}}
	<p class="buttons_group">
		<a class="button_screen menu___generic_admin__add_one" rel="add" href="{ADD_URL*}"><span>{!ADD_CALENDAR_EVENT}</span></a>
	</p>
{+END}

<div class="box box___calendar_main_screen_interests">
	<h2 class="toggleable_tray_title">
		<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode);"><img alt="{!EXPAND}: {!INTERESTS}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand2}" srcset="{$IMG*,2x/trays/expand2} 2x" /></a>
		<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode);">{!INTERESTS}</a>
	</h2>

	<div class="toggleable_tray" style="{$JS_ON,display: none,}" aria-expanded="false">
		<div class="float_surrounder">
			{+START,IF_NON_EMPTY,{EVENT_TYPES_1}}
				<div class="right event_interest_box"><section class="box"><div class="box_inner">
					<form title="{!INTERESTS}" method="post" action="{INTERESTS_URL*}" autocomplete="off">
						{$INSERT_SPAMMER_BLACKHOLE}

						<p><strong>{!DESCRIPTION_INTERESTS}</strong></p>

						<div class="calendar_main_page_hidden_data">
							{EVENT_TYPES_1}
						</div>

						<p class="proceed_button">
							<input onclick="disable_button_just_clicked(this);" class="button_screen buttons__choose" type="submit" value="{!INTERESTS}" />
						</p>
					</form>
				</div></section></div>
			{+END}
			{+START,IF_NON_EMPTY,{EVENT_TYPES_2}}
				<div class="left event_interest_box"><section class="box"><div class="box_inner">
					<form title="{!FILTER}" action="{$URL_FOR_GET_FORM*,{FILTER_URL}}" method="get" autocomplete="off">
						{$INSERT_SPAMMER_BLACKHOLE}

						{$HIDDENS_FOR_GET_FORM,{FILTER_URL}}

						<p><strong>{!DESCRIPTION_INTERESTS_2}</strong></p>

						<div class="calendar_main_page_hidden_data">
							{EVENT_TYPES_2}
						</div>

						<p class="proceed_button">
							<input onclick="disable_button_just_clicked(this);" class="button_screen buttons__filter" type="submit" value="{!FILTER}" />
						</p>
					</form>
				</div></section></div>
			{+END}
		</div>
	</div>
</div>

{$, Commented out... bloat
{+START,IF,{$ADDON_INSTALLED,syndication_blocks}}
	<div class="box box___calendar_main_screen_feeds_to_overlay">
		<h2 class="toggleable_tray_title">
			<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode);"><img alt="{!EXPAND}: {!FEEDS_TO_OVERLAY}" title="{!EXPAND}" src="{$IMG*,1x/trays/expand2}" srcset="{$IMG*,2x/trays/expand2} 2x" /></a>
			<a class="toggleable_tray_button" href="#" onclick="return toggleable_tray(this.parentNode.parentNode);">{!FEEDS_TO_OVERLAY}</a>
		</h2>

		<div class="toggleable_tray" style="{$JS_ON,display: none,}" aria-expanded="false">
			{RSS_FORM}
		</div>
	</div>
{+END}
}
