(function ($cms) {
    'use strict';

    $cms.templates.wikiManageTreeScreen = function wikiManageTreeScreen() {
        if ($cms.dom.$('#tree_list__root_mtp_tree')) {
            $cms.createTreeList('mtp_tree', 'data/ajax_tree.php?hook=choose_wiki_page' + $cms.$KEEP, '', '');
        }
    };

    $cms.templates.wikiPost = function wikiPost(params, container) {
        var id = strVal(params.id);

        $cms.dom.on(container, 'click', '.js-click-checkbox-set-cell-mark-class', function (e, checkbox) {
            var cell = $cms.dom.$('#cell_mark_' + id);
            cell.classList.toggle('cns_on', checkbox.checked);
            cell.classList.toggle('cns_off', !checkbox.checked);
        });

        $cms.dom.on(container, 'click', '.js-click-show-wiki-merge-button', function (e, checkbox) {
            var wikiMergeButton = $cms.dom.$('#wiki_merge_button');
            wikiMergeButton.classList.remove('button_faded');
            $cms.dom.show(wikiMergeButton);
        });
    };

    $cms.templates.wikiPageScreen = function wikiPageScreen(params, container) {
        $cms.dom.on(container, 'click', '.js-click-btn-add-form-marked-posts', function (e, btn) {
            if (add_form_marked_posts(btn.form, 'mark_')) {
                $cms.ui.disableButton(btn);
            } else {
                e.preventDefault();
                window.fauxmodal_alert('{!NOTHING_SELECTED=;}');
            }
        });
    };
}(window.$cms));