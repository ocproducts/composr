"use strict";

function load_commandr()
{
	// (Still?) loading
	if ((typeof window.commandr_command_response=='undefined') || (typeof window.do_ajax_request=='undefined'))
	{
		if (document.getElementById('commandr_img_loader'))
		{
			setTimeout(load_commandr,200);
			return false;
		}

		var img=document.getElementById('commandr_img');
		img.className='footer_button_loading';
		var tmp_element=document.createElement('img');
		tmp_element.src='{$IMG;,loading}'.replace(/^https?:/,window.location.protocol);
		tmp_element.style.position='absolute';
		tmp_element.style.left=(find_pos_x(img)+2)+'px';
		tmp_element.style.top=(find_pos_y(img)+1)+'px';
		tmp_element.id='commandr_img_loader';
		img.parentNode.appendChild(tmp_element);

		require_javascript('ajax',window.do_ajax_request);
		require_javascript('commandr',window.commandr_handle_history);
		require_css('commandr');
		window.setTimeout(load_commandr,200);
		return false;
	}

	// Loaded
	if ((typeof window.do_ajax_request!='undefined') && (typeof window.commandr_command_response!='undefined'))
	{
		confirm_session(
			function(result)
			{
				// Remove "loading" indicator from button
				var img=document.getElementById('commandr_img');
				var tmp_element=document.getElementById('commandr_img_loader');
				if (tmp_element) tmp_element.parentNode.removeChild(tmp_element);

				if (!result) return;

				// Set up Commandr window
				var commandr_box=document.getElementById('commandr_box');
				if (!commandr_box)
				{
					commandr_box=document.createElement('div');
					commandr_box.setAttribute('id','commandr_box');
					commandr_box.style.position='absolute';
					commandr_box.style.zIndex=2000;
					commandr_box.style.left=(get_window_width()-800)/2+'px';
					var top_temp=(get_window_height()-600)/2;
					if (top_temp<100) top_temp=100;
					commandr_box.style.top=top_temp+'px';
					commandr_box.style.display='none';
					commandr_box.style.width='800px';
					commandr_box.style.height='500px';
					document.body.appendChild(commandr_box);
					set_inner_html(commandr_box,load_snippet('commandr'));
				}

				if (commandr_box.style.display=='none') // Showing Commandr again
				{
					commandr_box.style.display='block';

					if (img)
					{
						img.src='{$IMG;,icons/24x24/tool_buttons/commandr_off}'.replace(/^https?:/,window.location.protocol);
						if (typeof img.srcset!='undefined')
							img.srcset='{$IMG;,icons/48x48/tool_buttons/commandr_off} 2x'.replace(/^https?:/,window.location.protocol);
						img.className='';
					}

					smooth_scroll(0,null,null,function() { document.getElementById('commandr_command').focus(); });
					if (typeof window.fade_transition!='undefined')
					{
						set_opacity(document.getElementById('command_line'),0.0);
						fade_transition(document.getElementById('command_line'),90,30,5);
					}

					var bi=document.getElementById('main_website_inner');
					if (bi)
					{
						if (typeof window.fade_transition!='undefined')
						{
							set_opacity(bi,1.0);
							fade_transition(bi,30,30,-5);
						} else
						{
							set_opacity(bi,0.3);
						}
					}

					document.getElementById('commandr_command').focus();
				}
				else // Hiding Commandr
				{
					if (img)
					{
						img.src='{$IMG;,icons/24x24/tool_buttons/commandr_on}'.replace(/^https?:/,window.location.protocol);
						if (typeof img.srcset!='undefined')
							img.srcset='{$IMG;,icons/48x48/tool_buttons/commandr_on} 2x'.replace(/^https?:/,window.location.protocol);
						set_opacity(img,1.0);
					}

					commandr_box.style.display='none';
					var bi=document.getElementById('main_website_inner');
					if (bi)
					{
						if (typeof window.fade_transition!='undefined')
						{
							fade_transition(bi,100,30,5);
						} else
						{
							set_opacity(bi,1.0);
						}
					}
				}
			}
		);

		return false;
	}

	// Fallback to link to module
	var btn=document.getElementById('commandr_button');
	if (btn)
		window.location.href=btn.href;
	return false;
}
