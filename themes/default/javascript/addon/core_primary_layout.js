
Composr.ready(function () {
    // GLOBAL_HTML_WRAP.tpl
    script_load_stuff();

    if (query_string_param('wide_print')) {
        try { window.print(); } catch (e) {}
    }
});
