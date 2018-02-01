{$SET,RAND_ID_PULSE,rand{$RAND}}
{$REQUIRE_JAVASCRIPT,pulse}

<span class="pulse-wave" id="pulse-wave-{$GET,RAND_ID_PULSE}" data-tpl="comcodePulse" data-tpl-params="{+START,PARAMS_JSON,RAND_ID_PULSE,MAX_COLOR,MIN_COLOR,SPEED}{_*}{+END}">{CONTENT}</span>
