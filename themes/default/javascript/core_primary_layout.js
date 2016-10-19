(function ($cms) {
    'use strict';

    $cms.views.GlobalHelperPanel = GlobalHelperPanel;

    function GlobalHelperPanel(params) {
        GlobalHelperPanel.base(this, arguments);
        this.contentsEl = this.$('.js-helper-panel-contents');
    }

    $cms.inherits(GlobalHelperPanel, $cms.View, {
        contentsEl: null,
        events: {
            'click .js-click-toggle-helper-panel': 'toggleHelperPanel'
        },
        toggleHelperPanel: function () {
            var show = !$cms.dom.isDisplayed(this.contentsEl, 'display');
            helper_panel(show);
        }
    });

    $cms.templates.globalHtmlWrap = function () {
        if (document.getElementById('global_messages_2')) {
            var m1 = document.getElementById('global_messages');
            if (!m1) return;
            var m2 = document.getElementById('global_messages_2');
            $cms.dom.appendHtml(m1, $cms.dom.html(m2));
            m2.parentNode.removeChild(m2);
        }

        if ($cms.usp.has('wide_print')) {
            try { window.print(); } catch (ignore) {}
        }
    };

    // The help panel
    function helper_panel(show) {
        var panel_right = document.getElementById('panel_right'),
            helper_panel_contents = document.getElementById('helper_panel_contents'),
            helper_panel_toggle = document.getElementById('helper_panel_toggle');

        if (show) {
            panel_right.classList.remove('helper_panel_hidden');
            helper_panel_contents.setAttribute('aria-expanded', 'true');
            helper_panel_contents.style.display = 'block';
            clear_transition_and_set_opacity(helper_panel_contents, 0.0);
            fade_transition(helper_panel_contents, 100, 30, 4);

            if (read_cookie('hide_helper_panel') === '1') {
                set_cookie('hide_helper_panel', '0', 100);
            }

            helper_panel_toggle.firstElementChild.src = $cms.img('{$IMG;,icons/14x14/helper_panel_hide}');
            if (helper_panel_toggle.firstElementChild.srcset !== undefined) {
                helper_panel_toggle.firstElementChild.srcset = $cms.img('{$IMG;,icons/28x28/helper_panel_hide} 2x');
            }
        } else {
            if (read_cookie('hide_helper_panel') == '') {
                window.fauxmodal_confirm('{!CLOSING_HELP_PANEL_CONFIRM;^}', function (answer) {
                    if (answer) {
                        _hide_helper_panel(panel_right, helper_panel_contents, helper_panel_toggle);
                    }
                });

                return;
            }
            _hide_helper_panel(panel_right, helper_panel_contents, helper_panel_toggle);
        }
    }

    function _hide_helper_panel(panel_right, helper_panel_contents, helper_panel_toggle) {
        panel_right.classList.add('helper_panel_hidden');
        helper_panel_contents.setAttribute('aria-expanded', 'false');
        helper_panel_contents.style.display = 'none';
        set_cookie('hide_helper_panel', '1', 100);
        helper_panel_toggle.firstElementChild.src = $cms.img('{$IMG;,icons/14x14/helper_panel_show}');

        if (helper_panel_toggle.firstElementChild.srcset !== undefined) {
            helper_panel_toggle.firstElementChild.srcset = $cms.img('{$IMG;,icons/28x28/helper_panel_show} 2x');
        }
    }
}(window.$cms));