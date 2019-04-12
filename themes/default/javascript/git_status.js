(function ($cms, $util, $dom) {
    'use strict';

    $cms.views.GitStatus = GitStatus;
    /**
     * @memberof $cms.views
     * @class $cms.views.GitStatus
     * @extends $cms.View
     */
    function GitStatus(params) {
        GitStatus.base(this, 'constructor', arguments);

        this.form = this.$('#git_status_form');
    }

    $util.inherits(GitStatus, $cms.View, /**@lends $cms.views.GitStatus#*/{
        events: function () {
            return {
                'click .js-btn-refresh-with-ignored': refreshWithIgnored,
                'click .js-btn-refresh-without-ignored': refreshWithoutIgnored,
                'click .js-btn-show-local-shell-paths': showLocalShellPaths,
                'click .js-btn-download-local-tar': downloadLocalTar,
                'click .js-btn-delete-local-changes': deleteLocalChanges,
                'click .js-git-local-select-all': localSelectAll,
                'click .js-git-local-select-none': localSelectNone,

                'click .js-btn-show-remote-shell-paths': showRemoteShellPaths,
                'click .js-btn-download-remote-tar': downloadRemoteTar,
                'click .js-git-remote-select-all': remoteSelectAll,
                'click .js-git-remote-select-none': remoteSelectNone,

                'click .js-btn-refresh-file-selected': refreshFileSelected
            };
        },

        refreshWithIgnored: function () {
            this.form.elements['action'].value = 'include';
        },

        refreshWithoutIgnored: function () {
            this.form.elements['action'].value = 'exclude';
        },

        showLocalShellPaths: function () {
            showShellPaths('local_select_');
        },

        downloadLocalTar: function () {
            this.form.elements['action'].value = 'local_tar';
        },

        deleteLocalChanges: function () {
            var _form = this.form;
            $cms.ui.confirm('Are you sure you want to delete the local changes?', function(result) {
                if (result) {
                    _form.elements['action'].value = 'revert';
                    _form.submit();
                }
            });
        },

        localSelectAll: function () {
            selectAllGitFiles('local_select_', true);
        },

        localSelectNone: function () {
            selectAllGitFiles('local_select_', false);
        },

        showRemoteShellPaths: function () {
            showShellPaths('remote_select_');
        },

        downloadRemoteTar: function () {
            this.form.elements['action'].value = 'remote_tar';
        },

        remoteSelectAll: function () {
            selectAllGitFiles('remote_select_', true);
        },

        remoteSelectNone: function () {
            selectAllGitFiles('remote_select_', false);
        },

        refreshFileSelected: function () {
            refreshFileSelection();
        }
    });

    function selectAllGitFiles(stub, select) {
        for (var i = 0; i < this.form.elements.length; i++) {
            if ((this.form.elements[i].nodeName.toLowerCase() == 'input') && (this.form.elements[i].name.substring(0, stub.length) == stub) && (!this.form.elements[i].disabled)) {
                this.form.elements[i].checked = select;
            }
        }

        refreshFileSelection();
    }

    function refreshFileSelection() {
        var hasSelection;

        hasSelection = _refreshFileSelection('local_select_');
        document.getElementById('button_local_tar').disabled = !hasSelection;
        document.getElementById('button_local_shell_paths').disabled = !hasSelection;
        document.getElementById('button_revert').disabled = !hasSelection;

        hasSelection = _refreshFileSelection('remote_select_');
        document.getElementById('button_remote_tar').disabled = !hasSelection;
        document.getElementById('button_remote_shell_paths').disabled = !hasSelection;
    }

    function _refreshFileSelection(stub) {
        for (var i = 0; i < this.form.elements.length; i++) {
            if ((this.form.elements[i].nodeName.toLowerCase() == 'input') && (this.form.elements[i].name.substring(0, stub.length) == stub) && (this.form.elements[i].checked) && (!this.form.elements[i].disabled)) {
                return true;
            }
        }

        return false;
    }

    function showShellPaths(stub, paths) {
        var notice = '';

        for (var i = 0; i < this.form.elements.length; i++) {
            if ((this.form.elements[i].nodeName.toLowerCase() == 'input') && (this.form.elements[i].name.substring(0, stub.length) == stub) && (this.form.elements[i].checked) && (!this.form.elements[i].disabled)) {
                if (notice != '') {
                    notice += ' \\\n';
                }
                notice += this.form.elements[i].value;
            }
        }

        $cms.ui.alert(notice, null, 'Paths');
    }
}(window.$cms, window.$util, window.$dom));
