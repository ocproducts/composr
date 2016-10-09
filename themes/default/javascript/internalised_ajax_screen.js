"use strict";

function detect_change(change_detection_url,refresh_if_changed,callback)
{
	do_ajax_request(change_detection_url,function(result) {
		var response=result.responseText;
		if (response=='1')
		{
			window.clearInterval(window.detect_interval);

			if (typeof window.console!='undefined')
				console.log('Change detected');

			callback();
		}
	},'refresh_if_changed='+window.encodeURIComponent(refresh_if_changed));
}

function detected_change()
{
	if (typeof window.console!='undefined')
		console.log('Change notification running');

	try
	{
		window.getAttention();
	}
	catch (e) {}
	try
	{
		window.focus();
	}
	catch (e) {}

	if (typeof window.soundManager!='undefined')
	{
		var sound_url='data/sounds/message_received.mp3';
		var base_url=((sound_url.indexOf('data_custom')==-1)&&(sound_url.indexOf('uploads/')==-1))?'{$BASE_URL_NOHTTP;}':'{$CUSTOM_BASE_URL_NOHTTP;}';
		var sound_object=window.soundManager.createSound({url: base_url+'/'+sound_url});
		if (sound_object) sound_object.play();
	}
}
