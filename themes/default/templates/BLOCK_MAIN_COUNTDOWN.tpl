{$REQUIRE_JAVASCRIPT,dyn_comcode}
{$REQUIRE_JAVASCRIPT,counting_blocks}

{$SET,countdown_id,countdown_{$RAND}}

<span id="{$GET,countdown_id}" role="timer" data-tpl-counting-blocks="blockMainCountdown"
	  data-tpl-args="{+START,PARAMS_JSON,POSITIVE,DISTANCE_FOR_PRECISION,TAILING,MILLISECONDS_FOR_PRECISION}{_*}{+END}">{LANG}</span>
