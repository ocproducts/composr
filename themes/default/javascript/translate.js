(function ($cms, $util, $dom) {
    'use strict';
    // ================
    // TRANSLATION PAGE
    // ================
    var $translate = window.$translate = {};
    // Call the hidden 'hack_form' to go run the translation site upon our language string, and direct into our personal iframe
    $translate.translate = function translate(id, old, langFrom, langTo) {
        id = strVal(id);
        old = strVal(old);
        langFrom = strVal(langFrom);
        langTo = strVal(langTo);
        
        var apiKey = '{$VALUE_OPTION;,google_translate_api_key}';

        if (langFrom === langTo) {
            langFrom = 'EN';
        }

        if (apiKey === '') {
            $cms.ui.toggleableTray($dom.$('#rexp_' + id));

            var element = document.getElementById('rexp_' + id);
            if (element.style.display !== 'none') {
                $dom.html('#exp_' + id, '<iframe src="{$BASE_URL_NOHTTP*;}/data/empty.html" id="iframe_' + id + '" name="iframe_' + id + '" class="translate_iframe">{!IGNORE^}</iframe>');
                var form = document.getElementById('hack_form');
                form.setAttribute('target', 'iframe_' + id);
                var inputText = document.getElementById('hack_input');
                inputText.value = old;
                $dom.submit(form);
            }
            
            return;
        } 
        
        var callbackName = 'googleTranslateCallback' + $util.random();

        window[callbackName] = function (response) {
            document.getElementById(id).value = response.data.translations[0].translatedText;
            delete window[callbackName];
        };

        var newScript = document.createElement('script');
        newScript.async = true;
        newScript.src = 'https://www.googleapis.com/language/translate/v2?key=' + encodeURIComponent(apiKey) + '&source=' + encodeURIComponent(langFrom) + '&target=' + encodeURIComponent(langTo) + '&callback=' + callbackName + '&q=' + encodeURIComponent(old);
        document.body.appendChild(newScript);
    };
}(window.$cms, window.$util, window.$dom));
