{$SET,RAND_ID_PULSE,rand{$RAND}}
{$REQUIRE_JAVASCRIPT,pulse}
<span class="pulse_wave" id="pulse_wave_{$GET,RAND_ID_PULSE}">{CONTENT}</span>
<script type="application/json" data-tpl-core-rich-media="comcodePulse">
	{+START,PARAMS_JSON,RAND_ID_PULSE,MAX_COLOR,MIN_COLOR,SPEED}{_/}{+END}
</script>