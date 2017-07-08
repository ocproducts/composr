/* TODO: Salman, merge this into core_cns.js */

'use strict';

function decryptData() {
    if (document.getElementById('decryption_overlay')) {
        return;
    }

    var container = document.createElement('div');
    container.className = 'decryption_overlay box';
    container.id = 'decryption_overlay';
    container.style.position = 'absolute';
    container.style.width = '26em';
    container.style.padding = '0.5em';
    container.style.left = ($cms.dom.getWindowWidth() / 2 - 200).toString() + 'px';
    container.style.top = ($cms.dom.getWindowHeight() / 2 - 100).toString() + 'px';
    try {
        scrollTo(0, 0);
    } catch (e) {}

    var title = document.createElement('h2');
    title.appendChild(document.createTextNode('{!encryption:DECRYPT_TITLE;^}'));
    container.appendChild(title);

    var description = document.createElement('p');
    description.appendChild(document.createTextNode('{!encryption:DECRYPT_DESCRIPTION;^}'));
    container.appendChild(description);

    var form = document.createElement('form');
    form.action = window.location.href;
    form.method = 'post';
    container.appendChild(form);

    var label = document.createElement('label');
    label.setAttribute('for', 'decrypt');
    label.appendChild(document.createTextNode('{!encryption:DECRYPT_LABEL;^}'));
    form.appendChild(label);

    var space = document.createTextNode(' ');
    form.appendChild(space);

    var token = document.createElement('input');
    token.type = 'hidden';
    token.name = 'csrf_token';
    token.id = 'csrf_token';
    token.value = $cms.getCsrfToken();
    form.appendChild(token);

    var input = document.createElement('input');
    input.type = 'password';
    input.name = 'decrypt';
    input.id = 'decrypt';
    form.appendChild(input);

    var proceedDiv = document.createElement('div');
    proceedDiv.className = 'proceed_button';
    proceedDiv.style.marginTop = '1em';

    // Cancel button
    var button = document.createElement('input');
    button.type = 'button';
    button.className = 'buttons__cancel button_screen_item';
    button.value = '{!INPUTSYSTEM_CANCEL;^}';
    // Remove the form when it's cancelled
    button.addEventListener('click', function () {
        document.body.removeChild(container);
        return false;
    });
    proceedDiv.appendChild(button);

    // Submit button
    button = document.createElement('input');
    button.type = 'submit';
    button.className = 'buttons__proceed button_screen_item';
    button.value = '{!encryption:DECRYPT;^}';
    // Hide the form upon submission
    button.addEventListener('click', function () {
        container.style.display = 'none';
    });
    proceedDiv.appendChild(button);

    form.appendChild(proceedDiv);

    document.body.appendChild(container);

    setTimeout(function () {
        try {
            input.focus();
        } catch (e) {}
    }, 0);
}
