(function ($, Composr) {
    'use strict';

    Composr.behaviors.coreZoneEditor = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core_zone_editor');
            }
        }
    };

    Composr.templates.coreZoneEditor = {
        zoneEditorPanel: function zoneEditorPanel(options) {
            options = options || {};

            if (Composr.isTruthy(options.comcode) && options.class.includes('wysiwyg')) {
                if ((window.wysiwyg_on) && (wysiwyg_on())) {
                    document.getElementById('edit_' + options.id + '_textarea').readOnly = true;
                }
            }
        }
    };

})(window.jQuery || window.Zepto, Composr);
