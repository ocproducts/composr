'use strict';

// ================
// TRANSLATION PAGE
// ================

// Call the hidden 'hack_form' to go run the translation site upon our language string, and direct into our personal iframe
function translate(name, old, langFrom, langTo) {
    var apiKey = '{$VALUE_OPTION;,google_translate_api_key}';

    if (langFrom == langTo) {
        langFrom = 'EN';
    }

    if (!apiKey) {
        $cms.ui.toggleableTray($cms.dom.$('#rexp_' + name));

        var element = document.getElementById('rexp_' + name);
        if (element.style.display !== 'none') {
            element = document.getElementById('exp_' + name);
            $cms.dom.html(element, '<iframe src="{$BASE_URL_NOHTTP*;}/data/empty.html" id="iframe_' + name + '" name="iframe_' + name + '" class="translate_iframe">{!IGNORE^}</iframe>');
            var form = document.getElementById('hack_form');
            form.setAttribute('target', 'iframe_' + name);
            var inputText = document.getElementById('hack_input');
            inputText.value = old;
            $cms.dom.submit(form);
        }
    } else {
        window.translating = name;

        var newScript = document.createElement('script');
        newScript.src = 'https://www.googleapis.com/language/translate/v2?key=' + encodeURIComponent(apiKey) + '&source=' + encodeURIComponent(langFrom) + '&target=' + encodeURIComponent(langTo) + '&callback=translateText&q=' + encodeURIComponent(old);
        document.head.appendChild(newScript);
    }
}

function translateText(response) {
    document.getElementById(window.translating).value = response.data.translations[0].translatedText;
}
