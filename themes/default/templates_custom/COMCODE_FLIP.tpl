{$REQUIRE_JAVASCRIPT,jquery}
{$REQUIRE_JAVASCRIPT,jquery_ui}
{$REQUIRE_JAVASCRIPT,jquery_flip}
{$REQUIRE_JAVASCRIPT,comcode_flip_tag}
{$REQUIRE_CSS,flip}

{$SET,RAND_FLIP,{$RAND}}

<div class="flipbox" id="flipbox-{$GET%,RAND_FLIP}" data-tpl="comcodeFlip" data-tpl-params="{+START,PARAMS_JSON,RAND_FLIP,FINAL_COLOR,SPEED,CONTENT}{_*}{+END}">
	{$COMCODE,{PARAM},0}
</div>
