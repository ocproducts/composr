"use strict";

// ===========
// Multi-field
// ===========

function deselect_alt_url(form)
{
	if (typeof form.elements['alt_url']!='undefined')
	{
		form.elements['alt_url'].value='';
	}
}

function _ensure_next_field(event,ob)
{
	if (typeof event=='undefined') event=window.event;
	if (enter_pressed(event)) goto_next_field(ob);
	else if (!key_pressed(event,9)) ensure_next_field(ob);
}

function goto_next_field(this_field)
{
	var mid=this_field.id.lastIndexOf('_');
	var name_stub=this_field.id.substring(0,mid+1);

	var this_num=this_field.id.substring(mid+1,this_field.id.length)-0;

	var next_num=this_num+1;
	var next_field=document.getElementById(name_stub+next_num);
	if (next_field)
	{
		try
		{
			next_field.focus();
		}
		catch (e) {}
	}
}

function ensure_next_field(this_field)
{
	var mid=this_field.id.lastIndexOf('_');
	var name_stub=this_field.id.substring(0,mid+1);

	var this_num=this_field.id.substring(mid+1,this_field.id.length)-0;

	var next_num=this_num+1;
	var next_field=document.getElementById(name_stub+next_num);
	var name=name_stub+next_num;
	var this_id=this_field.id;
	if (!next_field)
	{
		next_num=this_num+1;
		this_field=document.getElementById(this_id);
		var next_field_wrap=document.createElement('div');
		next_field_wrap.className=this_field.parentNode.className;
		var next_field;
		if (this_field.nodeName.toLowerCase()=='textarea')
		{
			next_field=document.createElement('textarea');
		} else
		{
			next_field=document.createElement('input');
			next_field.setAttribute('size',this_field.getAttribute('size'));
		}
		next_field.className=this_field.className.replace(/\_required/g,'');
		if (this_field.form.elements['label_for__'+name_stub+'0'])
		{
			var nextLabel=document.createElement('input');
			nextLabel.setAttribute('type','hidden');
			nextLabel.value=this_field.form.elements['label_for__'+name_stub+'0'].value+' ('+(next_num+1)+')';
			nextLabel.name='label_for__'+name_stub+next_num;
			next_field_wrap.appendChild(nextLabel);
		}
		next_field.setAttribute('tabindex',this_field.getAttribute('tabindex'));
		next_field.setAttribute('id',name_stub+next_num);
		if (this_field.onfocus) next_field.onfocus=this_field.onfocus;
		if (this_field.onblur) next_field.onblur=this_field.onblur;
		if (this_field.onkeyup) next_field.onkeyup=this_field.onkeyup;
		next_field.onkeypress=function(event) { _ensure_next_field(event,next_field); };
		if (this_field.onchange) next_field.onchange=this_field.onchange;
		if (typeof this_field.onrealchange!='undefined') next_field.onchange=this_field.onrealchange;
		if (this_field.nodeName.toLowerCase()!='textarea')
		{
			next_field.type=this_field.type;
		}
		next_field.value='';
		next_field.name=((this_field.name.indexOf('[]')==-1)?(name_stub+next_num):this_field.name);
		next_field_wrap.appendChild(next_field);
		this_field.parentNode.parentNode.insertBefore(next_field_wrap,this_field.parentNode.nextSibling);
	}
}

function _ensure_next_field_upload(event)
{
	if (typeof event=='undefined') event=window.event;
	if (!key_pressed(event,9)) ensure_next_field_upload(this);
}

function ensure_next_field_upload(this_field)
{
	var mid=this_field.name.lastIndexOf('_');
	var name_stub=this_field.name.substring(0,mid+1);
	var this_num=this_field.name.substring(mid+1,this_field.name.length)-0;

	var next_num=this_num+1;
	var next_field=document.getElementById('multi_'+next_num);
	var name=name_stub+next_num;
	var this_id=this_field.id;

	if (!next_field)
	{
		next_num=this_num+1;
		this_field=document.getElementById(this_id);
		var next_field=document.createElement('input');
		next_field.className='input_upload';
		next_field.setAttribute('id','multi_'+next_num);
		next_field.onchange=_ensure_next_field_upload;
		next_field.setAttribute('type','file');
		next_field.name=name_stub+next_num;
		this_field.parentNode.appendChild(next_field);
	}
}

