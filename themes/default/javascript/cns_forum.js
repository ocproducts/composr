"use strict";

function cns_check_poll(form,min,max,error)
{
	var j=0;
	for (var i=0;i<form.elements.length;i++)
		if ((form.elements[i].checked) && ((form.elements[i].type=='checkbox') || (form.elements[i].type=='radio'))) j++;
	var answer=((j>=min) && (j<=max));
	if (!answer)
	{
		window.fauxmodal_alert(error);
	} else
	{
		disable_button_just_clicked(form.elements['poll_vote_button']);
	}

	return answer;
}

function ignore_cns_notification(ignore_url,ob)
{
	do_ajax_request(ignore_url,function() {
		var o=ob.parentNode.parentNode.parentNode.parentNode;
		o.parentNode.removeChild(o);

		var nots=get_elements_by_class_name(document,'cns_member_column_pts');
		if ((nots[0]) && (get_elements_by_class_name(document,'cns_notification').length==0))
			nots[0].parentNode.removeChild(nots[0]);
	});

	return false;
}
