window.aceEditors || (window.aceEditors = {});

function aceComposrLoader(textareaId, programmingLanguage, autoRefresh) {
    if (typeof autoRefresh === 'undefined') {
        autoRefresh = true;
    }

    // Create Ace editor div from textarea
    var textarea = document.getElementById(textareaId);
    var val = textarea.value;
    var div = document.createElement('div');
    var aceId = textareaId + '__ace';
    div.id = aceId;
    div.style.height = (textarea.rows * 20) + 'px';
    textarea.style.display = 'none';
    textarea.parentNode.insertBefore(div, textarea);

    // Initialise Ace editor
    var editor = window.ace.edit(aceId);
    editor.setTheme('ace/theme/textmate');
    var editorSession = editor.getSession();
    editorSession.setMode('ace/mode/' + programmingLanguage);
    editorSession.setUseWrapMode(false);
    editor.setHighlightActiveLine(true);
    editor.setShowPrintMargin(false);
    editor.$blockScrolling = Infinity;
    if (val.indexOf('{+') !== -1 || val.indexOf('{$') !== -1) {
        // Troublesome Tempcode, so no syntax validation
        editorSession.setOption('useWorker', false);
    }

    // Save reference
    window.aceEditors[textareaId] = editor;

    // Keep textarea in sync with the Ace editor
    editorSession.setValue(val);
    if (autoRefresh) {
        editorSession.on('change', function () {
            editareaReverseRefresh(textareaId);
        });
    }
}

function editareaIsLoaded(textareaId) {
    return (typeof window.aceEditors[textareaId] !== 'undefined');
}

function editareaDoSearch(textareaId, regexp) {
    var editor = window.aceEditors[textareaId];

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
    var editor = window.aceEditors[textareaId];
    if (typeof editor === 'undefined') {
        return;
    }

    document.getElementById(textareaId).value = editor.getValue();
}

function editareaRefresh(textareaId) {
    var editor = window.aceEditors[textareaId];
    if (editor == null) {
        return;
    }

    editor.setValue(document.getElementById(textareaId).value, -1);
}

function editareaGetValue(textareaId) {
    var editor = window.aceEditors[textareaId];

    return editor.getValue();
}
