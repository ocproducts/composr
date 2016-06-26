{$REQUIRE_JAVASCRIPT,jquery}
{$REQUIRE_JAVASCRIPT,jquery_autocomplete,1}
{$REQUIRE_JAVASCRIPT,ajax,1}

{$REQUIRE_CSS,autocomplete}

add_event_listener_abstract(window,'load',function() {
	set_up_comcode_autocomplete('{NAME;/}'{+START,IF_PASSED_AND_TRUE,WYSIWYG},true{+END});
});
