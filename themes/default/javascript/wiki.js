(function ($, Composr) {
    // WIKI_MANAGE_TREE_SCREEN.tpl
    var wikiManageTreeScreen = _.once(function () {
        if (document.getElementById('mtp_tree')) {
            new tree_list('mtp_tree', 'data/ajax_tree.php?hook=choose_wiki_page' + Composr.$KEEP, '', '');
        }
    });

    Composr.behaviors.wiki = {
        initialize: {
            attach: function (context) {
                wikiManageTreeScreen();
            }
        }
    };
})(window.jQuery || window.Zepto, Composr);