(function ($cms) {

    $cms.templates.wikiManageTreeScreen = function() {
        if (document.getElementById('tree_list__root_mtp_tree')) {
            $cms.createTreeList('mtp_tree', 'data/ajax_tree.php?hook=choose_wiki_page' + $cms.$KEEP, '', '');
        }
    };

}(window.$cms));