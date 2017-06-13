"use strict";

if (typeof window.slideshow_timer=='undefined')
{
	window.slideshow_timer=null;
	window.slideshow_slides={};
	window.slideshow_time=null;
}

function initialise_slideshow()
{
	reset_slideshow_countdown();
	start_slideshow_timer();

	add_event_listener_abstract(window,'keypress',toggle_slideshow_timer);

	add_event_listener_abstract(document.getElementById('gallery_nav'),'click',function(event) {
		if (typeof event=='undefined') event=window.event;

		if (event.altKey || event.metaKey)
		{
			var b=document.getElementById('gallery_entry_screen');
			if (typeof b.webkitRequestFullScreen!='undefined') b.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT);
			if (typeof b.mozRequestFullScreenWithKeys!='undefined') b.mozRequestFullScreenWithKeys();
			if (typeof b.requestFullScreenWithKeys!='undefined') b.requestFullScreenWithKeys();
		} else
		{
			toggle_slideshow_timer();
		}
	});

	slideshow_show_slide(window.slideshow_current_position); // To ensure next is preloaded
}

function start_slideshow_timer()
{
	if (!window.slideshow_timer)
	{
		window.slideshow_timer=window.setInterval(function() {
			window.slideshow_time--;
			show_current_slideshow_time();

			if (window.slideshow_time==0)
			{
				slideshow_forward();
			}
		} ,1000);
	}

	if (window.slideshow_current_position!=window.slideshow_total_slides-1)
		document.getElementById('gallery_entry_screen').style.cursor='progress';
}

function show_current_slideshow_time()
{
	var changer=document.getElementById('changer_wrap');
	if (changer) set_inner_html(changer,'{!galleries:CHANGING_IN,xxx}'.replace('xxx',(window.slideshow_time<0)?0:window.slideshow_time));
}

function reset_slideshow_countdown()
{
	var slideshow_from=document.getElementById('slideshow_from');
	window.slideshow_time=slideshow_from?window.parseInt(slideshow_from.value):5;

	show_current_slideshow_time();

	if (window.slideshow_current_position==window.slideshow_total_slides-1)
		window.slideshow_time=0;
}

function toggle_slideshow_timer()
{
	if (window.slideshow_timer)
	{
		stop_slideshow_timer();
	} else
	{
		show_current_slideshow_time();
		start_slideshow_timer();
	}
}

function stop_slideshow_timer(message)
{
	if (typeof message=='undefined') message='{!galleries:STOPPED;^}';
	var changer=document.getElementById('changer_wrap');
	if (changer) set_inner_html(changer,message);
	if (window.slideshow_timer) window.clearInterval(window.slideshow_timer);
	window.slideshow_timer=null;
	document.getElementById('gallery_entry_screen').style.cursor='';
}

function slideshow_backward()
{
	if (window.slideshow_current_position==0) return false;

	slideshow_show_slide(window.slideshow_current_position-1);

	return false;
}

function player_stopped()
{
	slideshow_forward();
}

function slideshow_forward()
{
	if (window.slideshow_current_position==window.slideshow_total_slides-1)
	{
		stop_slideshow_timer('{!galleries:LAST_SLIDE;^}');
		return false;
	}

	slideshow_show_slide(window.slideshow_current_position+1);

	return false;
}

function slideshow_ensure_loaded(slide,callback)
{
	if (typeof window.slideshow_slides[slide]!='undefined')
	{
		if (typeof callback!='undefined')
		{
			callback();
		}
		return; // Already have it
	}

	if (window.slideshow_current_position==slide) // Ah, it's where we are, so save that in
	{
		window.slideshow_slides[slide]=get_inner_html(document.getElementById('gallery_entry_screen'));
		return;
	}

	if ((slide==window.slideshow_current_position-1) || (slide==window.slideshow_current_position+1))
	{
		var url;
		if (slide==window.slideshow_current_position+1)
			url=document.getElementById('next_slide').value;
		if (slide==window.slideshow_current_position-1)
			url=document.getElementById('previous_slide').value;

		if (typeof callback!='undefined')
		{
			do_ajax_request(url,function(ajax_result_raw) { _slideshow_read_in_slide(ajax_result_raw,slide); callback(); });
		} else
		{
			do_ajax_request(url,function(ajax_result_raw) { _slideshow_read_in_slide(ajax_result_raw,slide); });
		}
	} else
	{
		window.fauxmodal_alert('Internal error: should not be preloading more than one step ahead');
	}
}

function _slideshow_read_in_slide(ajax_result_raw,slide)
{
	window.slideshow_slides[slide]=ajax_result_raw.responseText.replace(/(.|\n)*<div class="gallery_entry_screen"[^<>]*>/i,'').replace(/<!--DO_NOT_REMOVE_THIS_COMMENT-->\s*<\/div>(.|\n)*/i,'');
}

function slideshow_show_slide(slide)
{
	slideshow_ensure_loaded(slide,function() {
		if (window.slideshow_current_position!=slide) // If not already here
		{
			var slideshow_from=document.getElementById('slideshow_from');

			var fade_elements_old=get_elements_by_class_name(document.body,'scale_down');
			if (typeof fade_elements_old[0]!='undefined')
			{
				var fade_element_old=fade_elements_old[0];
				var left_pos=find_width(fade_element_old.parentNode)/2-find_width(fade_element_old)/2;
				fade_element_old.style.left=left_pos+'px';
				fade_element_old.style.position='absolute';
			} // else probably a video

			var cleaned_slide_html=window.slideshow_slides[slide].replace(/<!DOCTYPE [^>]*>/i,'');
			set_inner_html(document.getElementById('gallery_entry_screen'),cleaned_slide_html);

			var fade_elements=get_elements_by_class_name(document.body,'scale_down');
			if ((typeof fade_elements[0]!='undefined') && (typeof fade_elements_old[0]!='undefined'))
			{
				var fade_element=fade_elements[0];
				set_opacity(fade_element,0);
				fade_element.parentNode.insertBefore(fade_element_old,fade_element);
				fade_element.parentNode.style.position='relative';
				fade_transition(fade_element,100.0,30,10);
				set_opacity(fade_element_old,1.0);
				fade_transition(fade_element_old,0.0,30,-10,true);
			} // else probably a video

			if (slideshow_from)
				document.getElementById('slideshow_from').value=slideshow_from.value; // Make sure stays the same

			window.slideshow_current_position=slide;

			if (typeof window.show_slide_callback!='undefined') show_slide_callback();
		}

		var fade_elements=get_elements_by_class_name(document.body,'scale_down');
		if (typeof fade_elements[0]!='undefined') // Is image
		{
			start_slideshow_timer();
			reset_slideshow_countdown();
		} else // Is video
		{
			stop_slideshow_timer('{!galleries:WILL_CONTINUE_AFTER_VIDEO_FINISHED}');
		}

		if (window.slideshow_current_position!=window.slideshow_total_slides-1)
			slideshow_ensure_loaded(slide+1);
		else
			document.getElementById('gallery_entry_screen').style.cursor='';
	});
}
