{$REQUIRE_JAVASCRIPT,modernizr}
{$REQUIRE_JAVASCRIPT,jquery}
{$REQUIRE_JAVASCRIPT,jquery_ui}
{$REQUIRE_JAVASCRIPT,widget_date}
{$REQUIRE_CSS,jquery_ui}
{$REQUIRE_CSS,widget_date}

{$SET,time_value,{$PAD_LEFT,{HOUR},2,0}:{$PAD_LEFT,{MINUTE},2,0}}
<input name="{NAME*}" id="{NAME*}" type="time" size="5"{+START,IF_PASSED,TABINDEX} tabindex="{TABINDEX*}"{+END} value="{+START,IF_NON_EMPTY,{HOUR}}{$GET*,time_value}{+END}"
	data-tpl-core-form-interfaces="formScreenInputTime" data-tpl-args="{+START,PARAMS_JSON,NAME}{_*}{+END}" />