(function ($, Composr) {
    Composr.templates.coreThemeing = {
        tempcodeTesterScreen: function tempcodeTesterScreen(options) {
            var form = this,
                button = form.querySelector('.js-btn-do-preview');

            button.addEventListener('click', function () {
                doTempcodeTesterPreview(form);
            });
        }
    };

    Composr.behaviors.coreThemeing = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_themeing');
            }
        }
    };

    function doTempcodeTesterPreview(form) {
        var request = '';

        for (var i = 0; i < form.elements.length; i++) {
            request += window.encodeURIComponent(form.elements[i].name) + '=' + window.encodeURIComponent(form.elements[i].value) + '&';
        }

        do_ajax_request('{$FIND_SCRIPT;,tempcode_tester}' + keep_stub(true), function (ajax_result) {
            set_inner_html(document.getElementById('preview_raw'), escape_html(ajax_result.responseText));
            set_inner_html(document.getElementById('preview_html'), ajax_result.responseText);
        }, request);

        do_ajax_request('{$FIND_SCRIPT;,tempcode_tester}?comcode=1' + keep_stub(), function (ajax_result) {
            set_inner_html(document.getElementById('preview_comcode'), ajax_result.responseText);
        }, request);

        return false;
    }
})(window.jQuery || window.Zepto, Composr);

