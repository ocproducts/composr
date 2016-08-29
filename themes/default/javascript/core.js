(function ($, Composr) {
    'use strict';

    Composr.behaviors.core = {
        initialize: {
            attach: function (context) {
                Composr.initializeViews(context, 'core');
                Composr.initializeTemplates(context, 'core');
            }
        }
    };

    Composr.templates.core = {
        globalHtmlWrap: function globalHtmlWrap(options) {
            options = options || {};

            script_load_stuff();

            if (Composr.isTruthy(Composr.queryString.get('wide_print'))) {
                try { window.print(); } catch (ignore) {}
            }

            if (Composr.isTruthy(options.bgTplCompilation)) {
                var page = Composr.filters.urlEncode(options.page);
                load_snippet('background_template_compilation&page=' + page, '', function () {});
            }
        },

        forumsEmbed: function () {
            var frame = this;
            Composr.assert(frame.dataset.tplCore === 'forumsEmbed', 'Template core.forumsEmbed must not be called with a script tag.');

            window.setInterval(function() { resize_frame(frame.name); }, 500);
        },

        massSelectFormButtons: function massSelectFormButtons(options) {
            var context = this;

            if (context.dataset.onClickMassSelectFormButtons !== '1') {
                context.dataset.onClickMassSelectFormButtons = '1';

                context.addEventListener('click', function (e) {
                    var delBtn = Composr.dom.closest(e.target, '.js-btn-mass-delete');
                    if (delBtn) {
                        massDeleteClick(delBtn);
                    }
                });
            }

            document.getElementById('id').fakeonchange = initialiseButtonVisibility;
            initialiseButtonVisibility();

            function initialiseButtonVisibility() {
                var id = document.getElementById('id');
                var ids = (id.value === '') ? [] : id.value.split(/,/);

                document.getElementById('submit_button').disabled = (ids.length != 1);
                document.getElementById('mass_select_button').disabled = (ids.length == 0);
            }

            function massDeleteClick(el) {
                confirm_delete(el.form, true, function () {
                    var id = document.getElementById('id');
                    var ids = (id.value === '') ? [] : id.value.split(/,/);

                    for (var i = 0; i < ids.length; i++) {
                        prepare_mass_select_marker('', options.type, ids[i], true);
                    }

                    ob.form.method = 'post';
                    ob.form.action = options.actionUrl;
                    ob.form.target = '_top';
                    ob.form.submit();
                });
            }
        },

        uploadSyndicationSetupScreen: function (id) {
            var win_parent = window.parent;
            if (!win_parent) win_parent = window.opener;

            var ob = win_parent.document.getElementById(id);
            ob.checked = true;

            var win = window;
            window.setTimeout(function () {
                if (typeof win.faux_close != 'undefined')
                    win.faux_close();
                else
                    win.close();
            }, 4000);
        },

        loginScreen: function loginScreen() {
            if ((typeof document.activeElement === 'undefined') || (document.activeElement !== document.getElementById('password'))) {
                try {
                    document.getElementById('login_username').focus();
                } catch (e){}
            }
        },

        jsBlock: function jsBlock() {
            call_block(options.blockCallUrl,'',document.getElementById(options.jsBlockId),false,null,false,null,false,false);
        }
    };
})(window.jQuery || window.Zepto, window.Composr);
