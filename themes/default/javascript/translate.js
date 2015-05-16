"use strict";

// ================
// TRANSLATION PAGE
// ================

// Call the hidden 'hack_form' to go run the translation site upon our language string, and direct into our personal iframe
function translate(name,old,lang_from,lang_to)
{
	var apiKey='{$VALUE_OPTION;,google_translate_api_key}';

	if (lang_from==lang_to) lang_from='EN';

	if (!apiKey)
	{
		toggleable_tray('rexp_'+name);

		var element=document.getElementById('rexp_'+name);
		if (element.style.display!='none')
		{
			element=document.getElementById('exp_'+name);
			set_inner_html(element,'<iframe src="{$BASE_URL_NOHTTP*;}/data/empty.html" id="iframe_'+name+'" name="iframe_'+name+'" class="translate_iframe">{!IGNORE^}</iframe>');
			var form=document.getElementById('hack_form');
			form.setAttribute('target','iframe_'+name);
			var input_text=document.getElementById('hack_input');
			input_text.value=old;
			form.submit();
		}
	} else
	{
		window.translating=name;

		var newScript=document.createElement('script');
		newScript.type='text/javascript';
		var source='https://www.googleapis.com/language/translate/v2?key='+window.encodeURIComponent(apiKey)+'&source='+window.encodeURIComponent(lang_from)+'&target='+window.encodeURIComponent(lang_to)+'&callback=translate_text&q='+window.encodeURIComponent(old);
		newScript.src=source;
		document.getElementsByTagName('head')[0].appendChild(newScript);
	}
}


function translate_text(response)
{
	document.getElementById(window.translating).value=response.data.translations[0].translatedText;
}
