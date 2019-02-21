"use strict";

// ================
// TRANSLATION PAGE
// ================

// Call the hidden 'hack_form' to go run the translation site upon our language string, and direct into our personal iframe
function translate_wrap(name,old,lang_from,lang_to)
{
	var apiKey='{$CONFIG_OPTION;^,google_translate_api_key}';

	if (lang_from==lang_to) lang_from='EN';

	window.translating=name;

	var newScript=document.createElement('script');
	newScript.type='text/javascript';
	var source='https://www.googleapis.com/language/translate/v2?key='+window.encodeURIComponent(apiKey)+'&source='+window.encodeURIComponent(lang_from)+'&target='+window.encodeURIComponent(lang_to)+'&callback=translate_text&q='+window.encodeURIComponent(old);
	newScript.src=source;
	document.getElementsByTagName('head')[0].appendChild(newScript);
}


function translate_text(response)
{
	document.getElementById(window.translating).value=response.data.translations[0].translatedText;
}
