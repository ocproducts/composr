"use strict";

// ==============
// MENU FUNCTIONS
// ==============

function menu_editor_add_new_page()
{
	var form=document.getElementById('edit_form');

	window.fauxmodal_prompt(
		'{$?,{$CONFIG_OPTION,collapse_user_zones},{!javascript:ENTER_ZONE_SPZ;^},{!javascript:ENTER_ZONE;^}}',
		'',
		function(zone)
		{
			if (zone!==null)
			{
				window.fauxmodal_prompt(
					'{!javascript:ENTER_PAGE;^}',
					'',
					function(page)
					{
						if (page!==null)
						{
							form.elements['url'].value=zone+':'+page;
						}
					},
					'{!menus:SPECIFYING_NEW_PAGE;^}'
				);
			}
		},
		'{!menus:SPECIFYING_NEW_PAGE;^}'
	);
}

function make_field_selected(ob)
{
	if (ob.className=='menu_editor_selected_field') return;

	ob.className='menu_editor_selected_field';
	var changed=false;
	for (var i=0;i<ob.form.elements.length;i++)
	{
		if ((ob.form.elements[i].className=='menu_editor_selected_field') && (ob.form.elements[i]!=ob))
		{
			ob.form.elements[i].className='';
			changed=true;
		}
	}

	copy_fields_into_bottom(ob.id.substr(8),changed);
}

function copy_fields_into_bottom(i,changed)
{
	window.current_selection=i;
	var form=document.getElementById('edit_form');

	form.elements['caption_long'].value=document.getElementById('caption_long_'+i).value;
	form.elements['caption_long'].onchange=function() { document.getElementById('caption_long_'+i).value=this.value; document.getElementById('caption_long_'+i).disabled=(this.value==''); };

	form.elements['url'].value=document.getElementById('url_'+i).value;
	form.elements['url'].onchange=function() { document.getElementById('url_'+i).value=this.value; };

	form.elements['page_only'].value=document.getElementById('page_only_'+i).value;
	form.elements['page_only'].onchange=function() { document.getElementById('page_only_'+i).value=this.value; document.getElementById('page_only_'+i).disabled=(this.value==''); };

	var s;
	for (s=0;s<form.elements['theme_img_code'].options.length;s++)
		if (document.getElementById('theme_img_code_'+i).value==form.elements['theme_img_code'].options[s].value) break;
	if (s==form.elements['theme_img_code'].options.length)
	{
		s=0;
		fauxmodal_alert('{!menus:MISSING_THEME_IMAGE_FOR_MENU;^}'.replace(/\\{1\\}/,document.getElementById('theme_img_code_'+i).value));
	}
	form.elements['theme_img_code'].selectedIndex=s;
	form.elements['theme_img_code'].onchange=function() { document.getElementById('theme_img_code_'+i).value=this.options[this.selectedIndex].value; document.getElementById('theme_img_code_'+i).disabled=(this.selectedIndex==0); };
	if (typeof $(form.elements['theme_img_code']).select2!='undefined') {
		$(form.elements['theme_img_code']).trigger('change');
	}

	form.elements['new_window'].checked=document.getElementById('new_window_'+i).value=='1';
	form.elements['new_window'].onclick=function() { document.getElementById('new_window_'+i).value=this.checked?'1':'0'; document.getElementById('new_window_'+i).disabled=!this.checked; };

	form.elements['check_perms'].checked=document.getElementById('check_perms_'+i).value=='1';
	form.elements['check_perms'].onclick=function() { document.getElementById('check_perms_'+i).value=this.checked?'1':'0'; document.getElementById('check_perms_'+i).disabled=!this.checked; };

	//set_inner_html(form.elements['branch_type'],get_inner_html(document.getElementById('branch_type_'+i))); Breaks in IE due to strict container rules
	form.elements['branch_type'].selectedIndex=document.getElementById('branch_type_'+i).selectedIndex;
	form.elements['branch_type'].onchange=function (event) {
		document.getElementById('branch_type_'+i).selectedIndex=this.selectedIndex;
		if (document.getElementById('branch_type_'+i).onchange) document.getElementById('branch_type_'+i).onchange(event);
	};
	if (typeof $(form.elements['branch_type']).select2!='undefined') {
		$(form.elements['branch_type']).trigger('change');
	}

	form.elements['include_sitemap'].selectedIndex=document.getElementById('include_sitemap_'+i).value;
	form.elements['include_sitemap'].onchange=function (event) { document.getElementById('include_sitemap_'+i).value=this.selectedIndex; document.getElementById('include_sitemap_'+i).disabled=(this.selectedIndex==0); };
	if (typeof $(form.elements['include_sitemap']).select2!='undefined') {
		$(form.elements['include_sitemap']).trigger('change');
	}

	var mfh=document.getElementById('mini_form_hider');

	mfh.style.display='block';

	if ((typeof window.fade_transition!='undefined'))
	{
		if (!changed)
		{
			set_opacity(mfh,0.0);
			fade_transition(mfh,100,30,4);
		} else
		{
			set_opacity(form.elements['url'],0.0);
			fade_transition(form.elements['url'],100,30,4);
		}
	}
}

function menu_editor_handle_keypress(e)
{
	if (typeof e=='undefined') e=window.event;
	var t=e.srcElement?e.srcElement:e.target;

	var up=(e.keyCode?e.keyCode:e.charCode)==38;
	var down=(e.keyCode?e.keyCode:e.charCode)==40;

	handle_ordering(t,up,down);
}

function branch_depth(branch)
{
	if (branch.parentNode) return branch_depth(branch.parentNode)+1;
	return 0;
}

function exists_child(elements,parent)
{
	for (var i=0;i<elements.length;i++)
	{
		if ((elements[i].name.substr(0,7)=='parent_') && (elements[i].value==parent)) return true;
	}
	return false;
}

function is_child(elements,possible_parent,possible_child)
{
	for (var i=0;i<elements.length;i++)
	{
		if ((elements[i].name.substr(7)==possible_child) && (elements[i].name.substr(0,7)=='parent_'))
		{
			if (elements[i].value==possible_parent) return true;
			return is_child(elements,possible_parent,elements[i].value);
		}
	}
	return false;
}

function handle_ordering(t,up,down)
{
	if ((up) || (down))
	{
		var form=document.getElementById('edit_form');

		// Find the num
		var index=t.id.substring(t.id.indexOf('_')+1,t.id.length);
		var num=window.parseInt(form.elements['order_'+index].value);

		// Find the parent
		var parent_num=document.getElementById('parent_'+index).value;

		var i,b,bindex;
		var best=-1,bestindex=-1;
	}

	if (up) // Up
	{
		// Find previous branch with same parent (if exists)
		for (i=0;i<form.elements.length;i++)
		{
			if ((form.elements[i].name.substr(0,7)=='parent_') &&
				 (form.elements[i].value==parent_num))
			{
				bindex=form.elements[i].name.substr(7,form.elements[i].name.length);
				b=window.parseInt(form.elements['order_'+bindex].value);
				if ((b<num) && (b>best))
				{
					best=b;
					bestindex=bindex;
				}
			}
		}
	}

	if (down) // Down
	{
		// Find next branch with same parent (if exists)
		for (i=0;i<form.elements.length;i++)
		{
			if ((form.elements[i].name.substr(0,7)=='parent_') &&
				 (form.elements[i].value==parent_num))
			{
				bindex=form.elements[i].name.substr(7,form.elements[i].name.length);
				b=window.parseInt(form.elements['order_'+bindex].value);
				if ((b>num) && ((b<best) || (best==-1)))
				{
					best=b;
					bestindex=bindex;
				}
			}
		}
	}

	if (((up) || (down))/* && (best==-1)*/)
	{
		var elements=form.getElementsByTagName('input');
		for (i=0;i<elements.length;i++)
		{
			if (elements[i].name=='parent_'+index) // Found our spot
			{
				var us=elements[i];
				for (b=up?(i-1):(i+1);up?(b>0):(b<elements.length);up?b--:b++)
				{
					if ((!is_child(elements,index,elements[b].name.substr(7))) && (elements[b].name.substr(0,7)=='parent_') && ((up) || (document.getElementById('branch_type_'+elements[b].name.substr(7)).selectedIndex==0) || (!exists_child(elements,elements[b].name.substr(7)))))
					{
						var target=elements[b];
						var main=us.parentNode.parentNode;
						var place=target.parentNode.parentNode;
						if (((up) && (branch_depth(target)<=branch_depth(us))) || ((down) && (branch_depth(target)!=branch_depth(us))))
						{
							main.parentNode.removeChild(main);
							place.parentNode.insertBefore(main,place);
						} else
						{
							main.parentNode.removeChild(main);
							if (!place.nextSibling)
							{
								place.parentNode.appendChild(main);
							} else
							{
								place.parentNode.insertBefore(main,place.nextSibling);
							}
						}
						us.value=target.value;
						return;
					}
				}
			}
		}
	}
}

function swap_names(t,a,b,t2,values_also)
{
	if (typeof t2=='undefined') t2='';
	if (typeof values_also=='undefined') values_also=false;
	var _a=document.getElementById(t+'_'+a+t2);
	var _b=document.getElementById(t+'_'+b+t2);
	_a.name=t+'_'+b+t2;
	_b.name=t+'_'+a+t2;
	_a.id=t+'_'+b+t2;
	_b.id=t+'_'+a+t2;
	if (values_also)
	{
		var temp=_a.value;
		_a.value=_b.value;
		_b.value=temp;
	}

	var _al=document.getElementById('label_'+t+'_'+a+t2);
	var _bl=document.getElementById('label_'+t+'_'+b+t2);
	if (_al)
	{
		_al.setAttribute('for',t+'_'+b+t2);
		_bl.setAttribute('for',t+'_'+a+t2);
		_al.id='label_'+t+'_'+b+t2;
		_bl.id='label_'+t+'_'+a+t2;
	}
}

function magic_copier(object,caption,url,error_message,confirm_message)
{
	var e=parent.document.getElementsByName('selected');

	var i,num,yes=false,target_type;
	for (i=0;i<e.length;i++)
	{
		if (e[i].checked)
		{
			num=e[i].value.substring(9,e[i].value.length);
			target_type=parent.document.getElementById('branch_type_'+num);
			if ((target_type.value=='page') || (target_type.getElementsByTagName('option').length<3))
			{
				if (parent.document.getElementById('url_'+num).value=='')
				{
					_do_magic_copier(num,url,caption);
				} else
				{
					window.fauxmodal_confirm(
						confirm_message,
						function(answer)
						{
							if (answer) _do_magic_copier(num,url,caption);
						}
					);
				}
			} else window.fauxmodal_alert(error_message);
			yes=true;
		}
	}
	if (!yes) window.fauxmodal_alert('{!javascript:RADIO_NOTHING_SELECTED;^}');

	return false;
}

function _do_magic_copier(num,url,caption)
{
	parent.document.getElementById('url_'+num).value=url;
	parent.document.getElementById('caption_'+num).value=caption;
}

function menu_editor_branch_type_change(id)
{
	var disabled=(document.getElementById('branch_type_'+id).value!='page');
	/*document.getElementById('new_window_'+id).disabled=disabled;
	document.getElementById('check_perms_'+id).disabled=disabled;
	document.getElementById('url_'+id).disabled=disabled;*/
	var sub=document.getElementById('branch_'+id+'_follow_1');
	if (sub)
	{
		sub.style.display=disabled?'block':'none';
	}
	sub=document.getElementById('branch_'+id+'_follow_2');
	if (sub) sub.style.display=disabled?'block':'none';
}

function delete_branch(id)
{
	var branch=document.getElementById(id);
	branch.parentNode.removeChild(branch);
}

function add_new_menu_item(parent_id,clickable_sections)
{
	var insert_before_id='branches_go_before_'+parent_id;

	var template=document.getElementById('template').value;

	var before=document.getElementById(insert_before_id);
	var new_id=Math.floor(Math.random()*10000);
	var template2=template.replace(/replace\_me\_with\_random/gi,new_id);
	var highest_order_element=document.getElementById('highest_order');
	var new_order=highest_order_element.value+1;
	highest_order_element.value++;
	template2=template2.replace(/replace\_me\_with\_order/gi,new_order);
	template2=template2.replace(/replace\_me\_with\_parent/gi,parent_id);

	// Backup form branches
	var form=document.getElementById('edit_form');
	var _elements_bak=form.elements,elements_bak=[];
	var i;
	for (i=0;i<_elements_bak.length;i++)
	{
		elements_bak.push([_elements_bak[i].name,_elements_bak[i].value]);
	}

	set_inner_html(before,template2,true); // Technically we are actually putting after "branches_go_before_XXX", but it makes no difference. It only needs to act as a divider.

	// Restore form branches
	for (i=0;i<elements_bak.length;i++)
	{
		if (elements_bak[i][0])
		{
			form.elements[elements_bak[i][0]].value=elements_bak[i][1];
		}
	}

	if (!clickable_sections) menu_editor_branch_type_change(new_id);

	//document.getElementById('selected_'+new_id).checked=true;

	document.getElementById('mini_form_hider').style.display='none';

	return false;
}

function check_menu()
{
	var form=document.getElementById('edit_form');
	var i,id,name,the_parent,ignore,caption,url,branch_type;
	for (i=0;i<form.elements.length;i++)
	{
		name=form.elements[i].name.substr(0,7);
		if (name=='parent_') // We don't care about this, but it does tell us we have found a menu branch ID
		{
			id=form.elements[i].name.substring(7,form.elements[i].name.length);

			// Is this visible? (if it is we need to check the IDs
			the_parent=form.elements[i];
			do
			{
				if (the_parent.style.display=='none')
				{
					ignore=true;
					break;
				}
				the_parent=the_parent.parentNode;
			}
			while (the_parent.parentNode);

			if (!ignore) // It's the real deal
			{
				// Check we have a caption
				caption=document.getElementById('caption_'+id);
				url=document.getElementById('url_'+id);
				if ((caption.value=='') && (url.value!=''))
				{
					window.fauxmodal_alert('{!MISSING_CAPTION_ERROR;^}');
					return false;
				}

				// If we are a page, check we have a URL
				branch_type=document.getElementById('branch_type_'+id);
				if (branch_type.options[branch_type.selectedIndex].value=='page')
				{
					if ((caption.value!='') && (url.value==''))
					{
						window.fauxmodal_alert('{!MISSING_URL_ERROR;^}');
						return false;
					}
				}
			}
		}
	}

	return true;
}

function delete_menu_branch(ob)
{
	var id=ob.id.substring(4,ob.id.length);

	if ((typeof window.showModalDialog!='undefined'{+START,IF,{$CONFIG_OPTION,js_overlays}} || true{+END}) || (ob.form.elements['branch_type_'+id]!='page'))
	{
		var choices={buttons__cancel: '{!INPUTSYSTEM_CANCEL;^}',menu___generic_admin__delete: '{!DELETE;^}',buttons__move: '{!menus:MOVETO_MENU;^}'};
		generate_question_ui(
			'{!CONFIRM_DELETE_LINK_NICE;^,xxxx}'.replace('xxxx',document.getElementById('caption_'+id).value),
			choices,
			'{!menus:DELETE_MENU_ITEM;^}',
			null,
			function(result)
			{
				if (result.toLowerCase()=='{!DELETE;^}'.toLowerCase())
				{
					delete_branch('branch_wrap_'+ob.name.substr(4,ob.name.length));
				} else if (result.toLowerCase()=='{!menus:MOVETO_MENU;^}'.toLowerCase())
				{
					var choices={buttons__cancel: '{!INPUTSYSTEM_CANCEL;^}'};
					for (var i=0;i<window.all_menus.length;i++)
					{
						choices['buttons__choose___'+i]=window.all_menus[i];
					}
					generate_question_ui(
						'{!menus:CONFIRM_MOVE_LINK_NICE;^,xxxx}'.replace('xxxx',document.getElementById('caption_'+id).value),
						choices,
						'{!menus:MOVE_MENU_ITEM;^}',
						null,
						function(result)
						{
							if (result.toLowerCase()!='{!INPUTSYSTEM_CANCEL;^}'.toLowerCase())
							{
								var post='',name,value;
								for (var i=0;i<ob.form.elements.length;i++)
								{
									name=ob.form.elements[i].name;
									if (name.substr(name.length-(('_'+id).length))=='_'+id)
									{
										if (ob.nodeName.toLowerCase()=='select')
										{
											value=ob.form.elements[i].value;
											myValue=ob.options[ob.selectedIndex].value;
										} else
										{
											if ((ob.type.toLowerCase()=='checkbox') && (!ob.checked)) continue;

											value=ob.form.elements[i].value;
										}
										if (post!='') post+='&';
										post+=name+'='+window.encodeURIComponent(value);
									}
								}
								do_ajax_request('{$FIND_SCRIPT_NOHTTP;,menu_management}'+'?id='+window.encodeURIComponent(id)+'&menu='+window.encodeURIComponent(result)+keep_stub(),null,post);
								delete_branch('branch_wrap_'+ob.name.substr(4,ob.name.length));
							}
						}
					);
				}
			}
		);
	} else
	{
		window.fauxmodal_confirm(
			'{!CONFIRM_DELETE_LINK;^,xxxx}'.replace('xxxx',document.getElementById('caption_'+id).value),
			function(result)
			{
				if (result)
					delete_branch('branch_wrap_'+ob.name.substr(4,ob.name.length));
			}
		);
	}
}
