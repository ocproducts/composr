<script>// <![CDATA[
	var main_window=get_main_cms_window();

	var post=main_window.document.getElementById('post');

	// Replace Comcode
	var old_comcode=main_window.get_textbox(post);
	main_window.set_textbox(post,'{NEW_POST_VALUE;^/}'.replace(/&#111;/g,'o').replace(/&#79;/g,'O'),'{NEW_POST_VALUE_HTML;^/}');

	// Turn main post editing back on
	if (typeof wysiwyg_set_readonly!='undefined') wysiwyg_set_readonly('post',false);

	// Remove attachment uploads
	var inputs=post.form.elements,upload_button;
	var i,done_one=false;
	for (i=0;i<inputs.length;i++)
	{
		if (((inputs[i].type=='file') || ((inputs[i].type=='text') && (inputs[i].disabled))) && (inputs[i].value!='') && (inputs[i].name.match(/file\d+/)))
		{
			if (typeof inputs[i].plupload_object!='undefined')
			{
				if ((inputs[i].value!='-1') && (inputs[i].value!=''))
				{
					if (!done_one)
					{
						if (old_comcode.indexOf('attachment_safe')==-1)
						{
							window.fauxmodal_alert('{!javascript:ATTACHMENT_SAVED;^}');
						} else
						{
							if (!main_window.is_wysiwyg_field(post)) // Only for non-WYSIWYG, as WYSIWYG has preview automated at same point of adding
								window.fauxmodal_alert('{!javascript:ATTACHMENT_SAVED;^}');
						}
					}
					done_one=true;
				}

				if (typeof inputs[i].plupload_object.setButtonDisabled!='undefined')
				{
					inputs[i].plupload_object.setButtonDisabled(false);
				} else
				{
					upload_button=main_window.document.getElementById('uploadButton_'+inputs[i].name);
					if (upload_button) upload_button.disabled=true;
				}
				inputs[i].value='-1';
			} else
			{
				try
				{
					inputs[i].value='';
				}
				catch (e) { };
			}
			if (typeof inputs[i].form.elements['hidFileID_'+inputs[i].name]!='undefined')
				inputs[i].form.elements['hidFileID_'+inputs[i].name].value='';
		}
	}
//]]></script>


