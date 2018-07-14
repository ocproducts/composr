{$,NB: INTERESTED is what clicking will make it, not what it currently is set to}

{+START,IF_NON_EMPTY,{INTERESTED}}
	{$REQUIRE_JAVASCRIPT,calendar}
	<div class="calendar-event-type" data-tpl="calendarEventType">
		<div class="clearfix zebra-{$CYCLE%,zebedee,0,1} js-click-toggle-checkbox-event-type">
			<div class="event-interested left">
				<label for="{S*}int_{TYPE_ID*}">{TYPE*}:</label>
			</div>
			<div class="right">
				<input class="js-checkbox-event-type" type="checkbox" value="1" id="{S*}int_{TYPE_ID*}" name="int_{TYPE_ID*}"{+START,IF,{$EQ,{INTERESTED},not_interested}} checked="checked"{+END} />
			</div>
		</div>
	</div>
{+END}
