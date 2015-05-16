"use strict";

function detect_change(change_detection_url,refresh_if_changed,callback)
{
	do_ajax_request(change_detection_url,function(result) {
		var response=result.responseText;
		if (response=='1')
		{
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
				window.soundManager.play('message_received');
			}

			window.clearInterval(window.detect_interval);

			callback();
		}
	},'refresh_if_changed='+window.encodeURIComponent(refresh_if_changed));
}
