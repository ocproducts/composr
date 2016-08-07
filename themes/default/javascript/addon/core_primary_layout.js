
$(function () {
    // GLOBAL_HTML_WRAP.tpl
    script_load_stuff();

    if (get_param('wide_print')) {
        try { window.print(); } catch (e) {}
    }
});