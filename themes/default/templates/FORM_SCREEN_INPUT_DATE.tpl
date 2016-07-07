{$REQUIRE_JAVASCRIPT,modernizr}
{$REQUIRE_JAVASCRIPT,jquery}
{$REQUIRE_JAVASCRIPT,jquery_ui}
{$REQUIRE_JAVASCRIPT,widget_date}
{$REQUIRE_CSS,jquery_ui}
{$REQUIRE_CSS,widget_date}

{$SET,date_value,{$PAD_LEFT,{YEAR},4,0}-{$PAD_LEFT,{MONTH},2,0}-{$PAD_LEFT,{DAY},2,0}}
{$SET,date_value_min,{$?,{$IS_NON_EMPTY,{MIN_DATE_YEAR}},{$PAD_LEFT,{MIN_DATE_YEAR},4,0}-{$PAD_LEFT,{MIN_DATE_MONTH},2,0}-{$PAD_LEFT,{MIN_DATE_DAY},2,0}}}
{$SET,date_value_max,{$?,{$IS_NON_EMPTY,{MAX_DATE_YEAR}},{$PAD_LEFT,{MAX_DATE_YEAR},4,0}-{$PAD_LEFT,{MAX_DATE_MONTH},2,0}-{$PAD_LEFT,{MAX_DATE_DAY},2,0}}}
<input name="{NAME*}" id="{NAME*}" type="date" size="10"{+START,IF_PASSED,TABINDEX} tabindex="{TABINDEX*}"{+END} value="{+START,IF_NON_EMPTY,{YEAR}}{$GET*,date_value}{+END}"{+START,IF_NON_EMPTY,{$GET,date_value_min}} min="{$GET*,date_value_min}"{+END}{+START,IF_NON_EMPTY,{$GET,date_value_max}} max="{$GET*,date_value_max}"{+END} class="input_date{$?,{REQUIRED},_required}" />

{+START,IF,{$EQ,{TYPE},datetime}}
	{$SET,time_value,{$PAD_LEFT,{HOUR},2,0}:{$PAD_LEFT,{MINUTE},2,0}}
	<label class="accessibility_hidden" for="{NAME*}_time">{!TIME}</label>
	<input name="{NAME*}_time" id="{NAME*}_time" type="time" size="5"{+START,IF_PASSED,TABINDEX} tabindex="{TABINDEX*}"{+END} value="{+START,IF_NON_EMPTY,{HOUR}}{$GET*,time_value}{+END}" class="input_time{$?,{REQUIRED},_required}" />
{+END}

{+START,SET,comment}
	Uncomment if you want to force jQuery-UI inputs even when there is native browser input support
	<script>// <![CDATA[
		add_event_listener_abstract(window,'load',function() {
			$('#{NAME;/}').inputDate({});
			$('#{NAME;/}_time').inputTime({});
		});
	//]]></script>
{+END}
