"use strict";

/*{$,Parser hint: .innerHTML okay}*/

/*
This provides the JavaScript necessary for the "status" part of activities

You can make use of it via require_javascript('activities_state',window.s_update_submit)
*/

function s_update_focus(event)
{
	if ($(this).val().trim()=='{!activities:TYPE_HERE;}')
	{
		$(this).val('');
		this.className=this.className.replace(/ field_input_non_filled/g,' field_input_filled');
	}
	$(this).removeClass('fade_input');
}

function s_update_blur(event)
{
	if ($(this).val().trim()=='')
	{
		$(this).val('{!activities:TYPE_HERE;}');
		this.className=this.className.replace(/ field_input_filled/g,' field_input_non_filled');
	}
	$(this).addClass('fade_input');
}

/**
 * Maintain feedback on how many characters are available in an update box.
 */
function s_maintain_char_count(event)
{
	var char_count=$('#activity_status').val().length;

	if (char_count<255)
		$('#activities_update_notify','#status_updates').attr('class','update_success').text((254-char_count)+' {!activities:CHARACTERS_LEFT;}');
	else
		$('#activities_update_notify','#status_updates').attr('class','update_error').text((char_count-254)+' {!activities:CHARACTERS_TOO_MANY;}');
}

/**
 * Called on update submission
 */
function s_update_submit(event)
{
	var subject_text='';

	if (event)
	{
		event.preventDefault();
		subject_text=$('textarea',this).val().trim();
	} else
	{
		subject_text=$('textarea','#fp_status_form').val().trim();
	}

	if ((subject_text=='{!activities:TYPE_HERE;}') || (subject_text==''))
	{
		$('#activities_update_notify','#status_updates').attr('class','update_error').text('{!activities:PLEASE_ENTER_STATUS;}');
	} else
	{
		var url='{$BASE_URL;,0}/data_custom/activities_handler.php'+keep_stub(true);

		jQuery.ajax({
			url: url.replace(/^https?:/,window.location.protocol),
			type: 'POST',
			data: $('#fp_status_form').serialize(),
			cache: false,
			timeout: 5000,
			success: function(data,stat) { s_update_retrieve(data,stat); },
			error: function(a,stat,err) { s_update_retrieve(err,stat); }
		});
	}
}

/**
 * Processes data retrieved for the activities feed and updates the list
 * If called by s_update_submit will also catch if you're logged out and redirect
 */
function s_update_retrieve(data,tStat)
{
	document.getElementById('button').disabled=false;

	var update_box=$('#activities_update_notify','#status_updates');
	if (tStat=='success')
	{
		if ($('success',data).text()=='0')
		{
			if ($('feedback',data).text().substr(0,13)=='{!MUST_LOGIN;}')
			{ //if refusal is due to login expiry...
				window.fauxmodal_alert('{!MUST_LOGIN;}');
			} else
			{
				update_box.attr('class','update_error').html($('feedback',data).text());
			}
		}
		else if ($('success',data).text()=='1')
		{
			update_box.attr('class','update_success').text($('feedback',data).text());
			if ($('#activities_feed').length!=0) // The update box won't necessarily have a displayed feed to update
			{
				s_update_get_data();
			}
			update_box.fadeIn(1200,function() { update_box.fadeOut(1200,function() {
				var as=$('#activity_status');
				update_box.attr('class','update_success').text('254 {!activities:CHARACTERS_LEFT;}');
				update_box.fadeIn(1200);
				as.parent().height(as.parent().height());
				as.val('{!activities:TYPE_HERE;}');
				as[0].className=as[0].className.replace(/ field_input_filled/g,' field_input_non_filled');
				as.fadeIn(1200,function() { as.parent().height(''); });
			}); });
		}
	} else
	{
		var errText='{!activities:WENT_WRONG;}';
		update_box.attr('class','').addClass('update_error').text(errText);
		update_box.hide();
		update_box.fadeIn(1200,function() { update_box.delay(2400).fadeOut(1200,function() {
			s_maintain_char_count(null);
			update_box.fadeIn(1200);
		}); });
	}
}
