(function ($cms) {
    'use strict';

    $cms.views.GlobalHelperPanel = GlobalHelperPanel;
    /**
     * @memberof $cms.views
     * @class
     * @extends $cms.View
     */
    function GlobalHelperPanel(params) {
        GlobalHelperPanel.base(this, 'constructor', arguments);
        this.contentsEl = this.$('.js-helper-panel-contents');
    }

    $cms.inherits(GlobalHelperPanel, $cms.View, /**@lends GlobalHelperPanel#*/{
        events: function () {
            return {
                'click .js-click-toggle-helper-panel': 'toggleHelperPanel'
            };
        },
        toggleHelperPanel: function () {
            var show = $cms.dom.notDisplayed(this.contentsEl),
                panelRight = $cms.dom.$('#panel_right'),
                helperPanelContents = $cms.dom.$('#helper_panel_contents'),
                helperPanelToggle = $cms.dom.$('#helper_panel_toggle');

            if (show) {
                panelRight.classList.remove('helper_panel_hidden');
                helperPanelContents.setAttribute('aria-expanded', 'true');
                helperPanelContents.style.display = 'block';
                $cms.dom.clearTransitionAndSetOpacity(helperPanelContents, 0.0);
                $cms.dom.fadeTransition(helperPanelContents, 100, 30, 4);

                if ($cms.readCookie('hide_helper_panel') === '1') {
                    $cms.setCookie('hide_helper_panel', '0', 100);
                }

                helperPanelToggle.firstElementChild.src = $cms.img('{$IMG;,icons/14x14/helper_panel_hide}');

                if (helperPanelToggle.firstElementChild.srcset !== undefined) {
                    helperPanelToggle.firstElementChild.srcset = $cms.img('{$IMG;,icons/28x28/helper_panel_hide} 2x');
                }
            } else {
                if ($cms.readCookie('hide_helper_panel') === '') {
                    $cms.ui.confirm('{!CLOSING_HELP_PANEL_CONFIRM;^}', function (answer) {
                        if (answer) {
                            _hideHelperPanel(panelRight, helperPanelContents, helperPanelToggle);
                        }
                    });
                } else {
                    _hideHelperPanel(panelRight, helperPanelContents, helperPanelToggle);

                }
            }

            function _hideHelperPanel(panelRight, helperPanelContents, helperPanelToggle) {
                panelRight.classList.add('helper_panel_hidden');
                helperPanelContents.setAttribute('aria-expanded', 'false');
                helperPanelContents.style.display = 'none';
                $cms.setCookie('hide_helper_panel', '1', 100);
                helperPanelToggle.firstElementChild.src = $cms.img('{$IMG;,icons/14x14/helper_panel_show}');

                if (helperPanelToggle.firstElementChild.srcset !== undefined) {
                    helperPanelToggle.firstElementChild.srcset = $cms.img('{$IMG;,icons/28x28/helper_panel_show} 2x');
                }
            }
        }
    });

    $cms.templates.globalHtmlWrap = function () {
        if (document.getElementById('global_messages_2')) {
            var m1 = document.getElementById('global_messages');
            if (!m1) {
                return;
            }
            var m2 = document.getElementById('global_messages_2');
            $cms.dom.append(m1, $cms.dom.html(m2));
            m2.parentNode.removeChild(m2);
        }

        if ($cms.usp.has('wide_print')) {
            try { window.print(); } catch (ignore) {}
        }
    };
}(window.$cms));
