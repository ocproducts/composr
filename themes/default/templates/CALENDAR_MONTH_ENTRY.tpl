<div class="calendar-month-entry">
	<a title="{TITLE*}{+START,IF,{$LT,{$LENGTH,{ID}},10}}: #{ID*}{+END}" href="{URL*}"><img width="24" height="24" src="{$IMG*,{ICON}}" title="{+START,IF_NON_EMPTY,{TIME}}{TIME*} &ndash; {+END}{TITLE*}" alt="{+START,IF_NON_EMPTY,{TIME}}{TIME*} &ndash; {+END}{TITLE*}" /></a>{+START,IF,{RECURRING}} {!REPEAT_SUFFIX}{+END}
</div>
