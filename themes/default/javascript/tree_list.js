"use strict";

window.tree_list=function(name,hook,root_id,options,multi_selection,tabindex,all_nodes_selectable,use_server_id)
{
	if (typeof window.do_ajax_request=='undefined') return;
	if (typeof use_server_id=='undefined') use_server_id=false;

	if ((typeof multi_selection=='undefined') || (!multi_selection)) var multi_selection=false;

	this.name=name;
	this.hook=hook;
	this.options=options;
	this.multi_selection=multi_selection;
	this.tabindex=tabindex?tabindex:null;
	this.all_nodes_selectable=all_nodes_selectable;
	this.use_server_id=use_server_id;

	var element=document.getElementById('tree_list__root_'+name);
	set_inner_html(element,'<div class="ajax_loading vertical_alignment"><img src="'+'{$IMG*;,loading}'.replace(/^https?:/,window.location.protocol)+'" alt="" /> <span>{!LOADING;^}</span></div>');

	// Initial rendering
	var url='{$BASE_URL_NOHTTP;}/'+hook;
	if (root_id!==null) url+='&id='+window.encodeURIComponent(root_id);
	url+='&options='+options;
	url+='&default='+window.encodeURIComponent(document.getElementById(name).value);
	do_ajax_request(url,this);

	register_mouse_listener();
};

tree_list.prototype.tree_list_data='';
tree_list.prototype.busy=false;
tree_list.prototype.last_clicked=null; // The hyperlink object that was last clicked (usage during multi selection when holding down shift)

/* Go through our tree list looking for a particular XML node */
tree_list.prototype.getElementByIdHack=function(id,type,ob,serverid)
{
	if ((typeof type=='undefined') || (!type)) var type='c';
	if ((typeof ob=='undefined') || (!ob)) var ob=this.tree_list_data;
	var i,test,done=false;
	// Normally we could only ever use getElementsByTagName, but Konqueror and Safari don't like it
	try // IE9 beta has serious problems
	{
		if ((typeof ob.getElementsByTagName!='undefined') && (typeof ob.getElementsByTagName!='unknown'))
		{
			var results=ob.getElementsByTagName((type=='c')?'category':'entry');
			for (i=0;i<results.length;i++)
			{
				if ((typeof results[i].getAttribute!='undefined') && (typeof results[i].getAttribute!='unknown') && (results[i].getAttribute(serverid?'serverid':'id')==id))
				{
					return results[i];
				}
			}
			done=true;
		}
	}
	catch (e) {}
	if (!done)
	{
		for (i=0;i<ob.childNodes.length;i++)
		{
			if (ob.childNodes[i].nodeName.toLowerCase()=='category')
			{
				test=this.getElementByIdHack(id,type,ob.childNodes[i],serverid);
				if (test)
				{
					return test;
				}
			}
			if ((ob.childNodes[i].nodeName.toLowerCase()==((type=='c')?'category':'entry')) && (ob.childNodes[i].getAttribute(serverid?'serverid':'id')==id))
				return ob.childNodes[i];
		}
	}
	return null;
};

tree_list.prototype.response=function(ajax_result_frame,ajax_result,expanding_id)
{
	if (!window.fixup_node_positions) return;

	ajax_result=careful_import_node(ajax_result);

	var i,xml,temp_node,html;
	if (!expanding_id) // Root
	{
		html=document.getElementById('tree_list__root_'+this.name);
		set_inner_html(html,'');

		this.tree_list_data=ajax_result.cloneNode(true);
		xml=this.tree_list_data;

		if (!has_child_nodes(xml))
		{
			var error=document.createTextNode((this.name.indexOf('category')==-1 && window.location.href.indexOf('category')==-1)?'{!NO_ENTRIES;^}':'{!NO_CATEGORIES;^}');
			html.className='red_alert';
			html.appendChild(error);
			return;
		}
	} else // Appending
	{
		xml=this.getElementByIdHack(expanding_id,'c');
		for (i=0;i<ajax_result.childNodes.length;i++)
		{
			temp_node=ajax_result.childNodes[i];
			xml.appendChild(temp_node.cloneNode(true));
		}
		html=document.getElementById(this.name+'tree_list_c_'+expanding_id);
	}

	attributes_full_fixup(xml);

	this.root_element=this.render_tree(xml,html);

	var name=this.name;
	fixup_node_positions(name);
	//window.setTimeout(function() { fixup_node_positions(name); },500);
};

function attributes_full_fixup(xml)
{
	var node,i;
	if (typeof window.attributes_full=='undefined') window.attributes_full={};
	var id=xml.getAttribute('id');
	if (typeof window.attributes_full[id]=='undefined') window.attributes_full[id]={};
	for (i=0;i<xml.attributes.length;i++)
	{
		window.attributes_full[id][xml.attributes[i].name]=xml.attributes[i].value;
	}
	for (i=0;i<xml.childNodes.length;i++)
	{
		node=xml.childNodes[i];

		if (node.nodeName=='#text') continue; // A text-node

		if ((node.nodeName.toLowerCase()=='category') || (node.nodeName.toLowerCase()=='entry'))
		{
			attributes_full_fixup(node);
		}
	}
}

function has_child_nodes(node)
{
	for (var i=0;i<node.childNodes.length;i++)
	{
		if (node.childNodes[i].nodeName!='#text') return true;
	}
	return false;
}

tree_list.prototype.render_tree=function(xml,html,element)
{
	if (!window.fixup_node_positions) return null;

	var i,colour,new_html,url,escaped_title;
	var initially_expanded,selectable,extra,url,title,func,temp,master_html,node,node_self_wrap,node_self;
	if ((typeof element=='undefined') || (!element)) var element=document.getElementById(this.name);

	if (typeof window.fade_transition!='undefined')
	{
		set_opacity(html,0.0);
		fade_transition(html,100,30,4);
	}

	html.style.display='block';
	if (!has_child_nodes(xml))
	{
		html.style.display='none';
	}

	for (i=0;i<xml.childNodes.length;i++)
	{
		node=xml.childNodes[i];
		if (node.nodeName=='#text') continue; // A text-node

		// Special handling of 'options' nodes, inject new options
		if (node.nodeName=='options')
		{
			this.options=window.encodeURIComponent(get_inner_html(node));
			continue;
		}

		// Special handling of 'expand' nodes, which say to pre-expand some categories as soon as the page loads
		if (node.nodeName=='expand')
		{
			var e=document.getElementById(this.name+'texp_c_'+get_inner_html(node));
			if (e)
			{
				var html_node=document.getElementById(this.name+'tree_list_c_'+get_inner_html(node));
				var expanding=(html_node.style.display!='block');
				if (expanding)
					e.onclick(null,true);
			} else
			{
				// Now try against serverid
				var xml_node=this.getElementByIdHack(get_inner_html(node),'c',null,true);
				if (xml_node)
				{
					var e=document.getElementById(this.name+'texp_c_'+xml_node.getAttribute('id'));
					if (e)
					{
						var html_node=document.getElementById(this.name+'tree_list_c_'+xml_node.getAttribute('id'));
						var expanding=(html_node.style.display!='block');
						if (expanding)
							e.onclick(null,true);
					}
				}
			}
			continue;
		}

		// Category or entry nodes
		extra=' ';
		func=node.getAttribute('img_func_1');
		if (func)
		{
			extra=extra+eval(func+'(node)');
		}
		func=node.getAttribute('img_func_2');
		if (func)
		{
			extra=extra+eval(func+'(node)');
		}
		node_self_wrap=document.createElement('div');
		node_self=document.createElement('div');
		node_self.style.display='inline-block';
		node_self_wrap.appendChild(node_self);
		node_self.object=this;
		colour=(node.getAttribute('selectable')=='true' || this.all_nodes_selectable)?'native_ui_foreground':'locked_input_field';
		selectable=(node.getAttribute('selectable')=='true' || this.all_nodes_selectable);
		if (node.nodeName.toLowerCase()=='category')
		{
			// Render self
			node_self.className=(node.getAttribute('highlighted')=='true')?'tree_list_highlighted':'tree_list_nonhighlighted';
			initially_expanded=(node.getAttribute('has_children')!='true') || (node.getAttribute('expanded')=='true');
			escaped_title=escape_html((typeof node.getAttribute('title')!='undefined')?node.getAttribute('title'):'');
			if (escaped_title=='') escaped_title='{!NA_EM;^}';
			var description='';
			var description_in_use='';
			if (node.getAttribute('description_html'))
			{
				description=node.getAttribute('description_html');
				description_in_use=escape_html(description);
			} else
			{
				if (node.getAttribute('description')) description=escape_html('. '+node.getAttribute('description'));
				description_in_use=escaped_title+': {!TREE_LIST_SELECT*;^}'+description+((node.getAttribute('serverid')=='')?(' ('+escape_html(node.getAttribute('serverid'))+')'):'');
			}
			set_inner_html(node_self,'<div><input class="ajax_tree_expand_icon"'+(this.tabindex?(' tabindex="'+this.tabindex+'"'):'')+' type="image" alt="'+((!initially_expanded)?'{!EXPAND;^}':'{!CONTRACT;^}')+': '+escaped_title+'" title="'+((!initially_expanded)?'{!EXPAND;^}':'{!CONTRACT;^}')+'" id="'+this.name+'texp_c_'+node.getAttribute('id')+'" src="'+((!initially_expanded)?'{$IMG*;,1x/treefield/expand}':'{$IMG*;,1x/treefield/collapse}').replace(/^https?:/,window.location.protocol)+'" srcset="'+((!initially_expanded)?'{$IMG*;,2x/treefield/expand}':'{$IMG*;,2x/treefield/collapse}').replace(/^https?:/,window.location.protocol)+' 2x" /> <img class="ajax_tree_cat_icon" alt="{!CATEGORY;^}" src="'+'{$IMG*;,1x/treefield/category}'.replace(/^https?:/,window.location.protocol)+'" srcset="'+'{$IMG*;,2x/treefield/category} 2x'.replace(/^https?:/,window.location.protocol)+'" /> <label id="'+this.name+'tsel_c_'+node.getAttribute('id')+'" for="'+this.name+'tsel_r_'+node.getAttribute('id')+'" onmouseout="if (typeof window.deactivate_tooltip!=\'undefined\') deactivate_tooltip(this);" onmousemove="if (typeof window.activate_tooltip!=\'undefined\') reposition_tooltip(this,event);" onmouseover="if (typeof window.activate_tooltip!=\'undefined\') activate_tooltip(this,event,'+(node.getAttribute('description_html')?'':'escape_html')+'(this.childNodes[0].title),\'auto\');" class="ajax_tree_magic_button '+colour+'"><input '+(this.tabindex?('tabindex="'+this.tabindex+'" '):'')+'id="'+this.name+'tsel_r_'+node.getAttribute('id')+'" style="position: absolute; left: -10000px" type="radio" name="_'+this.name+'" value="1" title="'+description_in_use+'" />'+escaped_title+'</label> <span id="'+this.name+'extra_'+node.getAttribute('id')+'">'+extra+'</span></div>');
			var expand_button=node_self.getElementsByTagName('input')[0];
			var _this=this;
			expand_button.oncontextmenu=function() { return false; };
			expand_button.object=this;
			expand_button.onclick=function(expand_button) { return function(event,automated) {
				if (document.getElementById('choose_'+_this.name)) click_link(document.getElementById('choose_'+_this.name));
				if (!event) var event=window.event;
				if (event)
				{
					event.returnValue=false;
					if (typeof event.preventDefault!='undefined') event.preventDefault();
				}
				_this.handle_tree_click.call(expand_button,event,automated);
				return false;
			}}(expand_button);
			var a=node_self.getElementsByTagName('label')[0];
			expand_button.onkeypress=a.onkeypress=a.childNodes[0].onkeypress=function(expand_button) {
				return function(event) {
					if (typeof event=='undefined') event=window.event;
					if (((event.keyCode?event.keyCode:event.charCode)==13) || ['+','-','='].indexOf(String.fromCharCode(event.keyCode?event.keyCode:event.charCode))!=-1)
						expand_button.onclick(event);
				}
			} (expand_button);
			a.oncontextmenu=function() { return false; };
			a.handle_selection=this.handle_selection;
			a.childNodes[0].onfocus=function() { this.parentNode.style.outline='1px dotted'; };
			a.childNodes[0].onblur=function() { this.parentNode.style.outline=''; };
			a.childNodes[0].onclick=a.handle_selection;
			a.onclick=a.handle_selection; // Needed by Firefox, the radio button's onclick will not be called if shift/ctrl held
			a.childNodes[0].object=this;
			a.object=this;
			a.onmousedown=function(event) { // To disable selection of text when holding shift or control
				if (event.ctrlKey || event.metaKey || event.shiftKey)
				{
					if (typeof event=='undefined') event=window.event;
					if (typeof event.preventDefault!='undefined') event.preventDefault();
				}
			};
			html.appendChild(node_self_wrap);

			// Do any children
			new_html=document.createElement('div');
			new_html.role='treeitem';
			new_html.id=this.name+'tree_list_c_'+node.getAttribute('id');
			new_html.style.display=((!initially_expanded) || (node.getAttribute('has_children')!='true'))?'none':'block';
			new_html.style.padding/*{$?,{$EQ,{!en_left},left},Left,Right}*/='15px';
			var selected=((this.use_server_id?node.getAttribute('serverid'):node.getAttribute('id'))==element.value && element.value!='') || node.getAttribute('selected')=='yes';
			if (selectable)
			{
				this.make_element_look_selected(document.getElementById(this.name+'tsel_c_'+node.getAttribute('id')),selected);
				if (selected)
				{
					element.value=(this.use_server_id?node.getAttribute('serverid'):node.getAttribute('id')); // Copy in proper ID for what is selected, not relying on what we currently have as accurate
					if (element.value!='')
					{
						if (typeof element.selected_title=='undefined') element.selected_title='';
						if (element.selected_title!='') element.selected_title+=',';
						element.selected_title+=node.getAttribute('title');
					}
					if (element.onchange) element.onchange();
					if (typeof element.fakeonchange!='undefined' && element.fakeonchange) element.fakeonchange();
				}
			}
			node_self.appendChild(new_html);

			// Auto-expand
			if (window.ctrl_pressed || window.alt_pressed || window.meta_pressed || window.shift_pressed)
			{
				if (!initially_expanded)
					expand_button.onclick();
			}
		} else // Assume entry
		{
			new_html=null;

			escaped_title=escape_html((typeof node.getAttribute('title')!='undefined')?node.getAttribute('title'):'');
			if (escaped_title=='') escaped_title='{!NA_EM;^}';

			var description='';
			var description_in_use='';
			if (node.getAttribute('description_html'))
			{
				description=node.getAttribute('description_html');
				description_in_use=escape_html(description);
			} else
			{
				if (node.getAttribute('description')) description=escape_html('. '+node.getAttribute('description'));
				description_in_use=escaped_title+': {!TREE_LIST_SELECT*;^}'+description+((node.getAttribute('serverid')=='')?(' ('+escape_html(node.getAttribute('serverid'))+')'):'');
			}

			// Render self
			initially_expanded=false;
			set_inner_html(node_self,'<div><img alt="{!ENTRY;^}" src="'+'{$IMG*;,1x/treefield/entry}'.replace(/^https?:/,window.location.protocol)+'" srcset="'+'{$IMG*;,2x/treefield/entry} 2x'.replace(/^https?:/,window.location.protocol)+'" style="width: 14px; height: 14px; padding-left: 16px" /> <label id="'+this.name+'tsel_e_'+node.getAttribute('id')+'" class="ajax_tree_magic_button '+colour+'" for="'+this.name+'tsel_s_'+node.getAttribute('id')+'" onmouseout="if (typeof window.deactivate_tooltip!=\'undefined\') deactivate_tooltip(this);" onmousemove="if (typeof window.activate_tooltip!=\'undefined\') reposition_tooltip(this,event);" onmouseover="if (typeof window.activate_tooltip!=\'undefined\') activate_tooltip(this,event,'+(node.getAttribute('description_html')?'':'escape_html')+'(\''+(description_in_use.replace(/\n/g,'').replace(/'/g,'\\'+'\''))+'\'),\'800px\');"><input'+(this.tabindex?(' tabindex="'+this.tabindex+'"'):'')+' id="'+this.name+'tsel_s_'+node.getAttribute('id')+'" style="position: absolute; left: -10000px" type="radio" name="_'+this.name+'" value="1" />'+escaped_title+'</label>'+extra+'</div>');
			var a=node_self.getElementsByTagName('label')[0];
			a.handle_selection=this.handle_selection;
			a.childNodes[0].onfocus=function() { this.parentNode.style.outline='1px dotted'; };
			a.childNodes[0].onblur=function() { this.parentNode.style.outline=''; };
			a.childNodes[0].onclick=a.handle_selection;
			a.onclick=a.handle_selection; // Needed by Firefox, the radio button's onclick will not be called if shift/ctrl held
			a.childNodes[0].object=this;
			a.object=this;
			a.onmousedown=function(event) { // To disable selection of text when holding shift or control
				if (event.ctrlKey || event.metaKey || event.shiftKey)
				{
					if (typeof event=='undefined') event=window.event;
					if (typeof event.preventDefault!='undefined') event.preventDefault();
				}
			};
			html.appendChild(node_self_wrap);
			var selected=((this.use_server_id?node.getAttribute('serverid'):node.getAttribute('id'))==element.value) || node.getAttribute('selected')=='yes';
			if ((this.multi_selection) && (!selected))
			{
				selected=((','+element.value+',').indexOf(','+node.getAttribute('id')+',')!=-1);
			}
			this.make_element_look_selected(document.getElementById(this.name+'tsel_e_'+node.getAttribute('id')),selected);
		}

		if ((node.getAttribute('draggable')) && (node.getAttribute('draggable')!='false'))
		{
			master_html=document.getElementById('tree_list__root_'+this.name);
			fix_up_node_position(node_self);
			node_self.cms_draggable=node.getAttribute('draggable');
			node_self.draggable=true;
			node_self.ondragstart=function(event) {
				clear_out_tooltips();

				this.className+=' being_dragged';

				window.is_doing_a_drag=true;
			};
			node_self.ondrag=function(event) {
				if (!event.clientY) return;
				var hit=find_overlapping_selectable(event.clientY+get_window_scroll_y(),this,this.object.tree_list_data,this.object.name);
				if (this.last_hit!=null)
				{
					this.last_hit.parentNode.parentNode.style.border='0px';
				}
				if (hit!=null)
				{
					hit.parentNode.parentNode.style.border='1px dotted green';
					this.last_hit=hit;
				}
			};
			node_self.ondragend=function(event) {
				window.is_doing_a_drag=false;

				this.className=this.className.replace(/ being_dragged/g,'');

				if (this.last_hit!=null)
				{
					this.last_hit.parentNode.parentNode.style.border='0px';

					if (this.parentNode.parentNode!=this.last_hit)
					{
						var xml_node=this.object.getElementByIdHack(this.getElementsByTagName('input')[0].id.substr(7+this.object.name.length));
						var target_xml_node=this.object.getElementByIdHack(this.last_hit.id.substr(12+this.object.name.length));

						if ((this.last_hit.childNodes.length==1) && (this.last_hit.childNodes[0].nodeName=='#text'))
						{
							set_inner_html(this.last_hit,'');
							this.object.render_tree(target_xml_node,this.last_hit);
						}

						// Change HTML
						this.parentNode.parentNode.removeChild(this.parentNode);
						this.last_hit.appendChild(this.parentNode);

						// Change node structure
						xml_node.parentNode.removeChild(xml_node);
						target_xml_node.appendChild(xml_node);

						// Ajax request
						eval('drag_'+xml_node.getAttribute('draggable')+'("'+xml_node.getAttribute('serverid')+'","'+target_xml_node.getAttribute('serverid')+'")');

						fixup_node_positions(this.object.name);
					}
				}
			};
		}

		if ((node.getAttribute('droppable')) && (node.getAttribute('droppable')!='false'))
		{
			node_self.ondragover=function(event) {
				if (typeof event.preventDefault!='undefined') event.preventDefault();
			};
			node_self.ondrop=function(event) {
				if (typeof event.preventDefault!='undefined') event.preventDefault();
				// ondragend will call with last_hit set, we don't track the drop spots using this event handler, we track it in real time using mouse coordinate analysis
			};
		}

		if (initially_expanded)
		{
			this.render_tree(node,new_html,element);
		} else
		{
			if (new_html) set_inner_html(new_html,'{!PLEASE_WAIT;^}',true);
		}
	}

	trigger_resize();

	return a;
};

function fixup_node_positions(name)
{
	var html=document.getElementById('tree_list__root_'+name);
	var to_fix=html.getElementsByTagName('div');
	var i;
	for (i=0;i<to_fix.length;i++)
	{
		if (to_fix[i].style.position=='absolute') fix_up_node_position(to_fix[i]);
	}
}

function fix_up_node_position(node_self)
{
	node_self.style.left=find_pos_x(node_self.parentNode,true)+'px';
	node_self.style.top=find_pos_y(node_self.parentNode,true)+'px';
}

function find_overlapping_selectable(mouse_y,element,node,name) // Find drop targets
{
	var i,childNode,temp,child_node_element,y,height;

	// Recursion
	if (node.getAttribute('expanded')!=='false')
	{
		for (i=0;i<node.childNodes.length;i++)
		{
			childNode=node.childNodes[i];
			if (childNode.nodeName=='#text') continue; // A text-node

			temp=find_overlapping_selectable(mouse_y,element,childNode,name);
			if (temp) return temp;
		}
	}

	if (node.getAttribute('droppable')==element.cms_draggable)
	{
		child_node_element=document.getElementById(name+'tree_list_'+((node.nodeName.toLowerCase()=='category')?'c':'e')+'_'+node.getAttribute('id'));
		y=find_pos_y(child_node_element.parentNode.parentNode,true);
		height=find_height(child_node_element.parentNode.parentNode);
		if ((y<mouse_y) && (y+height>mouse_y))
		{
			return child_node_element;
		}
	}

	return null;
}

tree_list.prototype.handle_tree_click=function(event,automated) // Not called as a method
{
	if (typeof window.do_ajax_request=='undefined') return false;

	var element=document.getElementById(this.object.name);
	if (element.disabled) return false;

	if (this.object.busy) return false;
	this.object.busy=true;

	var clicked_id=this.getAttribute('id').substr(7+this.object.name.length);

	var html_node=document.getElementById(this.object.name+'tree_list_c_'+clicked_id);
	var expand_button=document.getElementById(this.object.name+'texp_c_'+clicked_id);

	var expanding=(html_node.style.display!='block');

	if (expanding)
	{
		var xml_node=this.object.getElementByIdHack(clicked_id,'c');
		xml_node.setAttribute('expanded','true');
		var real_clicked_id=xml_node.getAttribute('serverid');
		if ((typeof real_clicked_id).toLowerCase()!='string') real_clicked_id=clicked_id;

		/*if ((xml_node.getAttribute('draggable')) && (xml_node.getAttribute('draggable')!='false'))
		{
			html_node.parentNode.style.position='static';
		}*/

		if ((xml_node.getAttribute('has_children')=='true') && (!has_child_nodes(xml_node)))
		{
			var url='{$BASE_URL_NOHTTP;}/'+this.object.hook+'&id='+window.encodeURIComponent(real_clicked_id)+'&options='+this.object.options+'&default='+window.encodeURIComponent(element.value);
			var ob=this.object;
			do_ajax_request(url,function (ajax_result_frame,ajax_result) { set_inner_html(html_node,''); ob.response(ajax_result_frame,ajax_result,clicked_id); });
			set_inner_html(html_node,'<div aria-busy="true" class="vertical_alignment"><img src="'+'{$IMG*;,loading}'.replace(/^https?:/,window.location.protocol)+'" alt="" /> <span>{!LOADING;^}</span></div>');
			var container=document.getElementById('tree_list__root_'+ob.name);
			if ((automated) && (container) && (container.style.overflowY=='auto'))
			{
				window.setTimeout(function() {
					container.scrollTop=find_pos_y(html_node)-20;
				}, 0);
			}
		}

		html_node.style.display='block';
		if (typeof window.fade_transition!='undefined')
		{
			set_opacity(html_node,0.0);
			fade_transition(html_node,100,30,4);
		}

		expand_button.src='{$IMG;,1x/treefield/collapse}'.replace(/^https?:/,window.location.protocol);
		expand_button.srcset='{$IMG;,2x/treefield/collapse}'.replace(/^https?:/,window.location.protocol)+' 2x';
		expand_button.title=expand_button.title.replace('{!EXPAND;^}','{!CONTRACT;^}');
		expand_button.alt=expand_button.alt.replace('{!EXPAND;^}','{!CONTRACT;^}');
	} else
	{
		var xml_node=this.object.getElementByIdHack(clicked_id,'c');
		xml_node.setAttribute('expanded','false');

		/*if ((xml_node.getAttribute('draggable')) && (xml_node.getAttribute('draggable')!='false'))
		{
			html_node.parentNode.style.position='absolute';
		}*/

		html_node.style.display='none';

		expand_button.src='{$IMG;,1x/treefield/expand}'.replace(/^https?:/,window.location.protocol);
		expand_button.srcset='{$IMG;,2x/treefield/expand}'.replace(/^https?:/,window.location.protocol)+' 2x';
		expand_button.title=expand_button.title.replace('{!CONTRACT;^}','{!EXPAND;^}');
		expand_button.alt=expand_button.alt.replace('{!CONTRACT;^}','{!EXPAND;^}');
	}

	fixup_node_positions(this.object.name);

	trigger_resize();

	this.object.busy=false;

	return true;
};

tree_list.prototype.handle_selection=function(event,assume_ctrl) // Not called as a method
{
	if (typeof event=='undefined') event=window.event;
	if (typeof assume_ctrl=='undefined') assume_ctrl=false;

	var element=document.getElementById(this.object.name);
	if (element.disabled) return;
	var i;
	var selected_before=(element.value=='')?[]:(this.object.multi_selection?element.value.split(','):[element.value]);

	cancel_bubbling(event);
	if (typeof event.preventDefault!='undefined') event.preventDefault();

	if ((!assume_ctrl) && (event.shiftKey) && (this.object.multi_selection))
	{
		// We're holding down shift so we need to force selection of everything bounded between our last click spot and here
		var all_a=document.getElementById('tree_list__root_'+this.object.name).getElementsByTagName('label');
		var pos_last=-1;
		var pos_us=-1;
		if (this.object.last_clicked==null) this.object.last_clicked=all_a[0];
		for (i=0;i<all_a.length;i++)
		{
			if (all_a[i]==this || all_a[i]==this.parentNode) pos_us=i;
			if (all_a[i]==this.object.last_clicked || all_a[i]==this.object.last_clicked.parentNode) pos_last=i;
		}
		if (pos_us<pos_last) // ReOrder them
		{
			var temp=pos_us;
			pos_us=pos_last;
			pos_last=temp;
		}
		var that_selected_id,that_xml_node,that_type;
		for (i=0;i<all_a.length;i++)
		{
			that_type=this.getAttribute('id').charAt(5+this.object.name.length);
			if (that_type=='r') that_type='c';
			if (that_type=='s') that_type='e';

			if (all_a[i].getAttribute('id').substr(5+this.object.name.length,that_type.length)==that_type)
			{
				that_selected_id=(this.object.use_server_id)?all_a[i].getAttribute('serverid'):all_a[i].getAttribute('id').substr(7+this.object.name.length);
				that_xml_node=this.object.getElementByIdHack(that_selected_id,that_type);
				if ((that_xml_node.getAttribute('selectable')=='true') || (this.object.all_nodes_selectable))
				{
					if ((i>=pos_last) && (i<=pos_us))
					{
						if (selected_before.indexOf(that_selected_id)==-1)
							all_a[i].handle_selection(event,true);
					} else
					{
						if (selected_before.indexOf(that_selected_id)!=-1)
							all_a[i].handle_selection(event,true);
					}
				}
			}
		}

		return;
	}
	var type=this.getAttribute('id').charAt(5+this.object.name.length);
	if (type=='r') type='c';
	if (type=='s') type='e';
	var real_selected_id=this.getAttribute('id').substr(7+this.object.name.length);
	var xml_node=this.object.getElementByIdHack(real_selected_id,type);
	var selected_id=(this.object.use_server_id)?xml_node.getAttribute('serverid'):real_selected_id;

	if (xml_node.getAttribute('selectable')=='true' || this.object.all_nodes_selectable)
	{
		var selected_after=selected_before;
		for (i=0;i<selected_before.length;i++)
		{
			this.object.make_element_look_selected(document.getElementById(this.object.name+'tsel_'+type+'_'+selected_before[i]),false);
		}
		if ((!this.object.multi_selection) || (((!event.ctrlKey) && (!event.metaKey) && (!event.altKey)) && (!assume_ctrl)))
		{
			selected_after=[];
		}
		if ((selected_before.indexOf(selected_id)!=-1) && (((selected_before.length==1) && (selected_before[0]!=selected_id)) || ((event.ctrlKey) || (event.metaKey) || (event.altKey)) || (assume_ctrl)))
		{
			for (var key in selected_after)
			{
				if (selected_after[key]==selected_id)
					selected_after.splice(key,1);
			}
		} else
		if (selected_after.indexOf(selected_id)==-1)
		{
			selected_after.push(selected_id);
			if (!this.object.multi_selection) // This is a bit of a hack to make selection look nice, even though we aren't storing natural IDs of what is selected
			{
				var anchors=document.getElementById('tree_list__root_'+this.object.name).getElementsByTagName('label');
				for (i=0;i<anchors.length;i++)
				{
					this.object.make_element_look_selected(anchors[i],false);
				}
				this.object.make_element_look_selected(document.getElementById(this.object.name+'tsel_'+type+'_'+real_selected_id),true);
			}
		}
		for (i=0;i<selected_after.length;i++)
		{
			this.object.make_element_look_selected(document.getElementById(this.object.name+'tsel_'+type+'_'+selected_after[i]),true);
		}

		element.value=selected_after.join(',');
		element.selected_title=(selected_after.length==1)?xml_node.getAttribute('title'):element.value;
		element.selected_editlink=xml_node.getAttribute('edit');
		if (element.value=='') element.selected_title='';
		if (element.onchange) element.onchange();
		if (typeof element.fakeonchange!='undefined' && element.fakeonchange) element.fakeonchange();
	}

	if (/*(!event.ctrlKey) && */(!assume_ctrl)) this.object.last_clicked=this;
};

tree_list.prototype.make_element_look_selected=function(target,selected)
{
	if (!target) return;
	if (!selected)
	{
		target.className=target.className.replace(/ native_ui_selected/g,'');
	} else
	{
		target.className+=' native_ui_selected';
	}
	target.style.cursor='pointer';
};


