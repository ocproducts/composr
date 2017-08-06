'use strict';

function loadCommandr() {
    $cms.requireCss('commandr');

    if (!document.getElementById('commandr_img_loader')) {
        var img = document.getElementById('commandr_img');
        img.className = 'footer_button_loading';
        var tmpElement = document.createElement('img');
        tmpElement.id = 'commandr_img_loader';
        tmpElement.src = $cms.img('{$IMG;,loading}');
        tmpElement.style.position = 'absolute';
        tmpElement.style.left = ($cms.dom.findPosX(img) + 2) + 'px';
        tmpElement.style.top = ($cms.dom.findPosY(img) + 1) + 'px';
        img.parentNode.appendChild(tmpElement);
    }

    $cms.requireJavascript('commandr').then(function () {
        $cms.ui.confirmSession(
            function (result) {
                // Remove "loading" indicator from button
                var img = document.getElementById('commandr_img'),
                    tmpElement = document.getElementById('commandr_img_loader');
                if (tmpElement) {
                    tmpElement.parentNode.removeChild(tmpElement);
                }

                if (!result) {
                    return;
                }

                // Set up Commandr window
                var commandrBox = document.getElementById('commandr_box');
                if (!commandrBox) {
                    commandrBox = document.createElement('div');
                    commandrBox.setAttribute('id', 'commandr_box');
                    commandrBox.style.position = 'absolute';
                    commandrBox.style.zIndex = 2000;
                    commandrBox.style.left = ($cms.dom.getWindowWidth() - 800) / 2 + 'px';
                    var topTemp = ($cms.dom.getWindowHeight() - 600) / 2;
                    if (topTemp < 100) {
                        topTemp = 100;
                    }
                    commandrBox.style.top = topTemp + 'px';
                    commandrBox.style.display = 'none';
                    commandrBox.style.width = '800px';
                    commandrBox.style.height = '500px';
                    document.body.appendChild(commandrBox);
                    /*TODO: Synchronous XHR*/
                    $cms.dom.html(commandrBox, $cms.loadSnippet('commandr'));
                }

                var bi;
                if ($cms.dom.notDisplayed(commandrBox)) { // Showing Commandr again
                    $cms.dom.show(commandrBox);

                    if (img) {
                        img.src = $cms.img('{$IMG;,icons/24x24/tool_buttons/commandr_off}');
                        if (img.srcset !== undefined)
                            img.srcset = $cms.img('{$IMG;,icons/48x48/tool_buttons/commandr_off} 2x');
                        img.className = '';
                    }

                    $cms.dom.smoothScroll(0, null, null, function () {
                        document.getElementById('commandr_command').focus();
                    });

                    var cmdLine = document.getElementById('command_line');
                    cmdLine.style.opacity = 0.0;
                    $cms.dom.fadeTo(cmdLine, null, 0.9);
                    
                    bi = document.getElementById('main_website_inner');
                    if (bi) {
                        bi.style.opacity = 1.0;
                        $cms.dom.fadeTo(bi, null, 0.3);
                    }

                    document.getElementById('commandr_command').focus();
                } else { // Hiding Commandr
                    if (img) {
                        img.src = $cms.img('{$IMG;,icons/24x24/tool_buttons/commandr_on}');
                        if (img.srcset !== undefined) {
                            img.srcset = $cms.img('{$IMG;,icons/48x48/tool_buttons/commandr_on}') + ' 2x';
                        }
                        img.style.opacity = 1.0;
                    }

                    commandrBox.style.display = 'none';
                    bi = document.getElementById('main_website_inner');
                    if (bi) {
                        $cms.dom.fadeIn(bi);
                    }
                }
            }
        );
    });
}
