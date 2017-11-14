(function ($cms) {
    'use strict';

    $cms.templates.wikiManageTreeScreen = function wikiManageTreeScreen(params, container) {
        if ($dom.$('#tree_list__root_mtp_tree')) {
            $cms.requireJavascript('tree_list').then(function () {
                $cms.ui.createTreeList('mtp_tree', 'data/ajax_tree.php?hook=choose_wiki_page' + $cms.keep(), '', '');
            });
        }

        $dom.on(container, 'change', '.js-change-input-tree-update-children-value', function (e, input) {
            if (input.value != '') {
                $dom.$('#children').value += input.value + '=' + input.selectedTitle + '\n';
            }
        });
    };

    $cms.templates.wikiPost = function wikiPost(params, container) {
        var id = strVal(params.id);

        $dom.on(container, 'click', '.js-click-checkbox-set-cell-mark-class', function (e, checkbox) {
            var cell = $dom.$('#cell_mark_' + id);
            cell.classList.toggle('cns_on', checkbox.checked);
            cell.classList.toggle('cns_off', !checkbox.checked);
        });

        $dom.on(container, 'click', '.js-click-show-wiki-merge-button', function (e, checkbox) {
            var wikiMergeButton = $dom.$('#wiki_merge_button');
            wikiMergeButton.classList.remove('button_faded');
            $dom.show(wikiMergeButton);
        });
    };

    $cms.templates.wikiPageScreen = function wikiPageScreen(params, container) {
        $dom.on(container, 'click', '.js-click-btn-add-form-marked-posts', function (e, btn) {
            if ($cms.form.addFormMarkedPosts(btn.form, 'mark_')) {
                $cms.ui.disableButton(btn);
            } else {
                e.preventDefault();
                $cms.ui.alert('{!NOTHING_SELECTED=;}');
            }
        });
    };
}(window.$cms));
