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

        var apiKey = '{$VALUE_OPTION;,google_apis_api_key}';

        if (langFrom === langTo) {
            langFrom = 'EN';
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
