(function ($, Composr) {
    Composr.templates.core = {
        uploadSyndicationSetupScreen: function (id) {
            var win_parent=window.parent;
            if (!win_parent) win_parent=window.opener;

            var ob=win_parent.document.getElementById(id);
            ob.checked=true;

            var win=window;
            window.setTimeout(function() {
                if (typeof win.faux_close!='undefined')
                    win.faux_close();
                else
                    win.close();
            }, 4000);
        }
    };

    Composr.behaviors.core = {
        initialize: {
            attach: function (context) {
                Composr.initializeTemplates(context, 'core');
            }
        }
    };
})(window.jQuery || window.Zepto, window.Composr);
