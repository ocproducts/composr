function showHide(elementid) {
	if (document.getElementById(elementid).style.display == 'none') {
		document.getElementById(elementid).style.display = '';
	} else {
		document.getElementById(elementid).style.display = 'none';
	}
}

function script_load_stuff_b()
{
	jQuery(document).ready(function() {
		// Back to top rocket...

		var offset = 220;
		var duration = 200;
		jQuery(window).scroll(function() {
			if (jQuery(this).scrollTop() > offset) {
				jQuery('.back-to-top').fadeIn(duration);
			} else {
				jQuery('.back-to-top').fadeOut(duration);
			}
		});

		jQuery('.back-to-top').click(function(event) {
			event.preventDefault();
			jQuery('html, body').animate({scrollTop: 0}, duration);
			return false;
		})

		// Placeholders...

		$('[placeholder]').focus(function() {
		  var input = $(this);
		  if (input.val() == input.attr('placeholder')) {
		    input.val('');
		    input.removeClass('placeholder');
		  }
		}).blur(function() {
		  var input = $(this);
		  if (input.val() == '' || input.val() == input.attr('placeholder')) {
		    input.addClass('placeholder');
		    input.val(input.attr('placeholder'));
		  }
		}).blur();
	});
}

function apply_tutorial_tooltip(link)
{
	add_event_listener_abstract(link,'mouseout',function(event) {
		if (typeof event=='undefined') event=window.event;
		if (typeof window.deactivate_tooltip!='undefined') deactivate_tooltip(link);
	});
	add_event_listener_abstract(link,'mousemove',function(event) {
		if (typeof event=='undefined') event=window.event;
		if (typeof window.activate_tooltip!='undefined') reposition_tooltip(link,event,false,false,null,true);
	});
	add_event_listener_abstract(link,'mouseover',function(event) {
		if (typeof event=='undefined') event=window.event;

		if (typeof window.activate_tooltip!='undefined')
		{
			if (typeof link.rendered_tooltip=='undefined')
			{
				link.is_over=true;

				var snippet_request='tutorial_box&tutorial_name='+window.encodeURIComponent(link.getAttribute('data-name'));
				var message=load_snippet(snippet_request,null,function(ajax_result) {
					link.rendered_tooltip=ajax_result.responseText;
					if (typeof link.rendered_tooltip!='undefined')
					{
						if (link.is_over)
							activate_tooltip(link,event,link.rendered_tooltip,'550px',null,null,false,false,false,true);
					}
				});
			} else
			{
				activate_tooltip(link,event,link.rendered_tooltip,'550px',null,null,false,false,false,true);
			}
		}
	});
};
