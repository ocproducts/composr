"use strict";

function handle_bookmark_selection(ob,id,event)
{
	var form=document.getElementById('selected_actions').getElementsByTagName('form')[0];

	var fields=document.getElementsByTagName('input'),i,some_checked=false;
	for (i=0;i<fields.length;i++)
	{
		if ((fields[i].name.substr(0,9)=='bookmark_') && (fields[i].checked))
		{
			some_checked=true;
		}
	}

	document.getElementById('selected_actions_some').style.display=some_checked?'block':'none';
	document.getElementById('selected_actions_none').style.display=some_checked?'none':'block';

	add_form_marked_posts(form,'bookmark_');

	var folder_list=document.getElementById('folder');
	var _fv=document.getElementById('folder_'+id);
	var fv=_fv?_fv.value:'';
	if (fv=='') fv='!';
	for (i=0;i<folder_list.options.length;i++)
	{
		if (folder_list.options[i].value==fv)
		{
			folder_list.selectedIndex=i;
			if (typeof $(folder_list).select2!='undefined') {
				$(folder_list).trigger('change');
			}
			if ((folder_list.onchange!='undefined') && (folder_list.onchange)) folder_list.onchange(event);
			if ((folder_list.fakeonchange!='undefined') && (folder_list.fakeonchange)) folder_list.fakeonchange(event);
			break;
		}
	}
}
