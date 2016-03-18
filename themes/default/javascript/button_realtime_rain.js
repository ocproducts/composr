"use strict";

function load_realtime_rain()
{
	if ((typeof window.realtime_rain_button_load_handler=='undefined') || (typeof window.do_ajax_request=='undefined'))
	{
		if (document.getElementById('realtime_rain_img_loader'))
		{
			setTimeout(load_realtime_rain,200);
			return false;
		}

		var img=document.getElementById('realtime_rain_img');
		img.className='footer_button_loading';
		var tmp_element=document.createElement('img');
		tmp_element.src='{$IMG;,loading}'.replace(/^https?:/,window.location.protocol);
		tmp_element.style.position='absolute';
		tmp_element.style.left=(find_pos_x(img)+2)+'px';
		tmp_element.style.top=(find_pos_y(img)+1)+'px';
		tmp_element.id='realtime_rain_img_loader';
		img.parentNode.appendChild(tmp_element);

		require_javascript('ajax',window.do_ajax_request);
		require_javascript('realtime_rain',window.start_realtime_rain);
		require_css('realtime_rain');
		window.setTimeout(load_realtime_rain,200);
		return false;
	}
	if ((typeof window.do_ajax_request!='undefined') && (typeof window.realtime_rain_button_load_handler!='undefined'))
	{
		return realtime_rain_button_load_handler();
	}
	window.location.href=document.getElementById('realtime_rain_button').href;
	return false;
}
