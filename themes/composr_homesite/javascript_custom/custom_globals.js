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
