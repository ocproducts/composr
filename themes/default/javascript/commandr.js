'use strict';

window.previous_commands || (window.previous_commands = []);
(window.current_command !== undefined) ||  (window.current_command = null);

(function ($cms) {
    'use strict';

    $cms.templates.commandrMain = function commandrMain(params, container) {
        $cms.dom.on(container, 'submit', '.js-submit-commandr-form-submission', function (e, form) {
            commandr_form_submission($cms.dom.$('#commandr_command').value, form);
        });

        $cms.dom.on(container, 'keyup', '.js-keyup-input-commandr-handle-history', function (e, input) {
            if (commandr_handle_history(input, e.keyCode ? e.keyCode : e.charCode, e) === false) {
                e.preventDefault();
            }
        });
    };

    $cms.templates.commandrLs = function commandrLs(params, container) {
        $cms.dom.on(container, 'click', '.js-click-set-directory-command', function (e, clicked) {
            var filename = strVal(clicked.dataset.tpFilename),
                commandInput = $cms.dom.$('#commandr_command');

            commandInput.value = 'cd "' + filename + '"';
            $cms.dom.trigger(commandInput.nextElementSibling, 'click');
        });

        $cms.dom.on(container, 'click', '.js-click-set-file-command', function (e, clicked) {
            var filename = strVal(clicked.dataset.tpFilename),
                commandInput = $cms.dom.$('#commandr_command');

            if (commandInput.value !== '') {
                commandInput.value = commandInput.value.replace(/\s*$/, '') + ' "' + filename + '"';
                commandInput.focus();
            } else {
                commandInput.value = 'cat "' + filename + '"';
                $cms.dom.trigger(commandInput.nextElementSibling, 'click');
            }
        });
    };

    $cms.templates.commandrCommands = function commandrCommands(params, container) {
        $cms.dom.on(container, 'click', '.js-click-enter-command', function (e, target) {
            var commandInput = $cms.dom.$('#commandr_command'),
                command = strVal(target.dataset.tpCommand);
            commandInput.value = command;
            commandInput.focus();
        });
    };

    $cms.templates.commandrEdit = function commandrEdit(params, container) {
        var file = strVal(params.file);

        $cms.dom.on(container, 'submit', '.js-submit-commandr-form-submission', function (e, form) {
            var command = 'write "' + file + '" "' + form.elements.edit_content.value.replace(/\\/g, '\\\\').replace(/</g, '\\<').replace(/>/g, '\\>').replace(/"/g, '\\"') + '"';
            commandr_form_submission(command, form);
        });
    };
}(window.$cms));

// Deal with Commandr history
function commandr_handle_history(element, key_code, e) {
    if ((key_code == 38) && (window.previous_commands.length > 0)) {// Up button
        cancel_bubbling(e);
        if (e.cancelable) {
            e.preventDefault();
        }

        if (window.current_command == null) {
            window.current_command = window.previous_commands.length - 1;
            element.value = window.previous_commands[window.current_command];
        }
        else if (window.current_command > 0) {
            window.current_command--;
            element.value = window.previous_commands[window.current_command];
        }
        return false;
    } else if ((key_code == 40) && (window.previous_commands.length > 0)) {// Down button

        cancel_bubbling(e);
        if (e.cancelable) {
            e.preventDefault();
        }

        if (window.current_command != null) {
            if (window.current_command < window.previous_commands.length - 1) {
                window.current_command++;
                element.value = window.previous_commands[window.current_command];
            }
            else {
                window.current_command = null;
                element.value = '';
            }
        }
        return false;
    } else {
        window.current_command = null;
        return true;
    }
}

// Submit an Commandr command
function commandr_form_submission(command, form) {
    // Catch the data being submitted by the form, and send it through XMLHttpRequest if possible. Stop the form submission if this is achieved.
    // var command=document.getElementById('commandr_command').value;

    if (window.do_ajax_request) {
        // Send it through XMLHttpRequest, and append the results.
        document.getElementById('commandr_command').focus();
        document.getElementById('commandr_command').disabled = true;

        var post = 'command=' + encodeURIComponent(command);
        post = modsecurity_workaround_ajax(post);
        do_ajax_request('{$FIND_SCRIPT;,commandr}' + keep_stub(true), commandr_command_response, post);

        window.disable_timeout = window.setTimeout(function () {
            document.getElementById('commandr_command').disabled = false;
            document.getElementById('commandr_command').focus();
            if (window.disable_timeout) {
                window.clearTimeout(window.disable_timeout);
                window.disable_timeout = null;
            }
        }, 5000);
        window.previous_commands.push(command);

        return false;
    } else if (form !== undefined) {
        // Let the form be submitted the old-fashioned way.
        return modsecurity_workaround(form);
    }
 }

// Deal with the response to a command
function commandr_command_response(ajax_result_frame, ajax_result) {
    if (window.disable_timeout) {
        window.clearTimeout(window.disable_timeout);
        window.disable_timeout = null;
    }

    document.getElementById('commandr_command').disabled = false;
    document.getElementById('commandr_command').focus();

    var command = document.getElementById('commandr_command');
    var command_prompt = document.getElementById('command_prompt');
    var cl = document.getElementById('commands_go_here');
    var new_command = document.createElement('div');
    var past_command_prompt = document.createElement('p');
    var past_command = document.createElement('div');

    new_command.setAttribute('class', 'command float_surrounder');
    past_command_prompt.setAttribute('class', 'past_command_prompt');
    past_command.setAttribute('class', 'past_command');

    if (!ajax_result) {
        var stderr_text = document.createTextNode('{!commandr:ERROR_NON_TERMINAL;^}\n{!INTERNAL_ERROR;^}');
        var stderr_text_p = document.createElement('p');
        stderr_text_p.setAttribute('class', 'error_output');
        stderr_text_p.appendChild(stderr_text);
        past_command.appendChild(stderr_text_p);

        new_command.appendChild(past_command);
        cl.appendChild(new_command);

        command.value = '';
        var cl2 = document.getElementById('command_line');
        cl2.scrollTop = cl2.scrollHeight;

        return;
    }

    // Deal with the response: add the result to the command_line
    var method = ajax_result.querySelector('command').textContent;
    var stdcommand = ajax_result.querySelector('stdcommand').textContent;
    var stdhtml = ajax_result.querySelector('stdhtml').firstElementChild;
    var stdout = ajax_result.querySelector('stdout').textContent;
    var stderr = ajax_result.querySelector('stderr').textContent;

    var past_command_text = document.createTextNode(method + ' \u2192 ');
    past_command_prompt.appendChild(past_command_text);

    new_command.appendChild(past_command_prompt);

    if (stdout != '') {
        // Text-only. Any HTML should've been escaped server-side. Escaping it over here with the DOM getting in the way is too complex.
        var stdout_text = document.createTextNode(stdout);
        var stdout_text_p = document.createElement('p');
        stdout_text_p.setAttribute('class', 'text_output');
        stdout_text_p.appendChild(stdout_text);
        past_command.appendChild(stdout_text_p);
    }

    if (stdhtml.childNodes) {
        var child_node, new_child, cloned_node;
        for (i = 0; i < stdhtml.childNodes.length; i++) {
            child_node = stdhtml.childNodes[i];
            new_child = careful_import_node(child_node);
            cloned_node = new_child.cloneNode(true);
            past_command.appendChild(cloned_node);
        }
    }

    if (stdcommand != '') {
        // JavaScript commands; eval() them.
        eval(stdcommand);

        var stdcommand_text = document.createTextNode('{!JAVASCRIPT_EXECUTED;^}');
        var stdcommand_text_p = document.createElement('p');
        stdcommand_text_p.setAttribute('class', 'command_output');
        stdcommand_text_p.appendChild(stdcommand_text);
        past_command.appendChild(stdcommand_text_p);
    }

    if ((stdcommand == '') && (!stdhtml.childNodes) && (stdout == '')) {
        // Exit with an error.
        if (stderr != '') var stderr_text = document.createTextNode('{!PROBLEM_ACCESSING_RESPONSE;^}\n' + stderr);
        else var stderr_text = document.createTextNode('{!TERMINAL_PROBLEM_ACCESSING_RESPONSE;^}');
        var stderr_text_p = document.createElement('p');
        stderr_text_p.setAttribute('class', 'error_output');
        stderr_text_p.appendChild(stderr_text);
        past_command.appendChild(stderr_text_p);

        return false;
    }
    else if (stderr != '') {
        var stderr_text = document.createTextNode('{!commandr:ERROR_NON_TERMINAL;^}\n' + stderr);
        var stderr_text_p = document.createElement('p');
        stderr_text_p.setAttribute('class', 'error_output');
        stderr_text_p.appendChild(stderr_text);
        past_command.appendChild(stderr_text_p);
    }

    new_command.appendChild(past_command);
    cl.appendChild(new_command);

    command.value = '';
    var cl2 = document.getElementById('command_line');
    cl2.scrollTop = cl2.scrollHeight;

    return true;
}

// Clear the command line
function clear_cl() {
    // Clear all results from the CL
    var command_line = document.getElementById('commands_go_here');
    var elements = command_line.querySelectorAll('.command');

    for (var i = 0; i < elements.length; i++) {
        command_line.removeChild(elements[i]);
    }
}

// Fun stuff...

window.commandr_foxy_textnodes || (window.commandr_foxy_textnodes = []);

function bsod() {
    // Nothing to see here, move along.
    var command_line = document.getElementById('commands_go_here');
    command_line.style.backgroundColor = '#0000FF';
    bsod_traverse_node(window.document.documentElement);
    setInterval(foxy, 1);
}

function foxy() {
    var rand = Math.round(Math.random() * (window.commandr_foxy_textnodes.length - 1));
    var t = window.commandr_foxy_textnodes[rand];
    var at = Math.round(Math.random() * (t.data.length - 1));
    var a_char = t.data.charCodeAt(at);
    if ((a_char > 33) && (a_char < 126)) {
        var string = 'The quick brown fox jumps over the lazy dog.';
        var rep = string.charAt(at % string.length);
        t.replaceData(at, 1, rep);
    }
}

function bsod_traverse_node(node) {
    var i, t;
    for (i = 0; i < node.childNodes.length; i++) {
        t = node.childNodes[i];
        if (t.nodeType == 3) {
            if ((t.data.length > 1) && (Math.random() < 0.3)) window.commandr_foxy_textnodes[window.commandr_foxy_textnodes.length] = t;
        }
        else bsod_traverse_node(t);
    }
}
