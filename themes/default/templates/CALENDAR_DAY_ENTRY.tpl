<div class="calendar-day-entry">
	<div class="float-surrounder">
		{+START,IF_NON_EMPTY,{ICON}}<img class="calendar-day-icon" src="{$IMG*,{ICON}}" title="{T_TITLE*}" alt="{T_TITLE*}" />{+END}
		<img class="calendar-day-priority" src="{$IMG*,{PRIORITY_ICON}}" title="{PRIORITY_LANG*}" alt="{PRIORITY_LANG*}" />
		<a title="{TITLE*}{+START,IF,{$LT,{$LENGTH,{ID}},10}}: #{ID*}{+END}" href="{URL*}" class="calendar-day-entry-title">{TITLE*}</a>
		{+START,IF,{RECURRING}} {!REPEAT_SUFFIX}{+END}
		<span class="calendar-day-entry-time">{TIME*}</span>
	</div>

	{+START,IF_NON_EMPTY,{DESCRIPTION}}
		<div class="calendar-day-entry-description">
			{$TRUNCATE_LEFT,{DESCRIPTION},{$MULT,{DOWN},20},,1}
		</div>
	{+END}
</div>
