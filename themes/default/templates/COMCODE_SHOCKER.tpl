{$SET,RAND_ID_SHOCKER,rand{$RAND}}

{$REQUIRE_JAVASCRIPT,core_rich_media}
{$REQUIRE_JAVASCRIPT,pulse}

<div class="shocker" data-tpl="comcodeShocker" data-tpl-args="{+START,PARAMS_JSON,RAND_ID_SHOCKER,PARTS,TIME,MAX_COLOR,MIN_COLOR}{_*}{+END}">
	<div class="shocker_left" id="comcodeshocker{$GET,RAND_ID_SHOCKER}_left"></div>
	<div class="shocker_right" id="comcodeshocker{$GET,RAND_ID_SHOCKER}_right"></div>
</div>

<noscript>
	{FULL*}
</noscript>

