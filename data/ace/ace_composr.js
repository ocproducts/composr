window.ace_editors || (window.ace_editors = {});

function aceComposrLoader(textareaId, programmingLanguage, autoRefresh) {
    if (typeof autoRefresh == 'undefined') autoRefresh = true;

    // Create Ace editor div from textarea
    var textarea = document.getElementById(textareaId);
    var val = textarea.value;
    var div = document.createElement('div');
    var ace_id = textareaId + '__ace';
    div.id = ace_id;
    div.style.height = (textarea.rows * 20) + 'px';
    textarea.style.display = 'none';
    textarea.parentNode.insertBefore(div, textarea);

    // Initialise Ace editor
    var editor = ace.edit(ace_id);
    editor.setTheme('ace/theme/textmate');
    var editor_session = editor.getSession();
    editor_session.setMode('ace/mode/' + programmingLanguage);
    editor_session.setUseWrapMode(false);
    editor.setHighlightActiveLine(true);
    editor.setShowPrintMargin(false);
    editor.$blockScrolling = Infinity;
    if (val.indexOf('{+') != -1 || val.indexOf('{$') != -1) {
        // Troublesome Tempcode, so no syntax validation
        editor_session.setOption('useWorker', false);
    }

    // Save reference
    window.ace_editors[textareaId] = editor;

    // Keep textarea in sync with the Ace editor
    editor_session.setValue(val);
    if (autoRefresh) {
        editor_session.on('change', function () {
            editareaReverseRefresh(textareaId);
        });
    }
}

function editareaIsLoaded(textareaId) {
    return (typeof window.ace_editors[textareaId] != 'undefined');
}

function editareaDoSearch(textareaId, regexp) {
    var editor = window.ace_editors[textareaId];

    editor.find(regexp, {
        wrap: true,
        caseSensitive: false,
        regExp: true
    });

    try {
        window.scrollTo(0, $cms.dom.findPosY(document.getElementById(textareaId).parentNode, true));
    } catch (e) {}
}

function editareaReverseRefresh(textareaId) {
    var editor = window.ace_editors[textareaId];
    if (typeof editor == 'undefined') return;

    document.getElementById(textareaId).value = editor.getValue();
}

function editareaRefresh(textareaId) {
    var editor = window.ace_editors[textareaId];
    if (editor == null) {
        return;
    }

    editor.setValue(document.getElementById(textareaId).value, -1);
}

function editareaGetValue(textareaId) {
    var editor = window.ace_editors[textareaId];

    return editor.getValue();
}
