/*{$REQUIRE_JAVASCRIPT,jquery}*/
/*{$REQUIRE_JAVASCRIPT,jquery_autocomplete,1}*/
/*{$REQUIRE_JAVASCRIPT,ajax,1}*/

/*{$REQUIRE_CSS,autocomplete}*/

$(function () {
    set_up_comcode_autocomplete('{NAME;/}'/*{+START,IF_PASSED_AND_TRUE,WYSIWYG}*/, true/*{+END}*/);
});
