"use strict";

window.template_editor_open_files={};

/*
Naming conventions...

t_	Tab header
g_	Tab body
b_ Toolbar
e_	Editor textbox
*/

function file_to_file_id(file)
{
	return file.replace(/\//,'__').replace(/:/,'__');
}

function template_editor_assign_unload_event()
{
	add_event_listener_abstract(window,'beforeunload',function(event) {
		if (!event) event=window.event;

		if (get_elements_by_class_name(document,'file_changed').length>0)
		{
			undo_staff_unload_action();
			window.unloaded=false;

			var ret='{!UNSAVED_TEMPLATE_CHANGES;^}';
			event.returnValue=ret; // Fix Chrome bug (explained on https://developer.mozilla.org/en-US/docs/Web/Events/beforeunload)
			return ret;
		}
		return null;
	});
}

/* Tab and file management */

function add_template()
{
	window.fauxmodal_prompt(
		'{!themes:INPUT_TEMPLATE_TYPE;^}',
		'templates',
		function(subdir) {
			if (subdir!==null)
			{
				if (subdir!='templates' && subdir!='css' && subdir!='javascript' && subdir!='text' && subdir!='xml'){
					window.fauxmodal_alert('{!BAD_TEMPLATE_TYPE;}');
					return;
				}

				window.fauxmodal_prompt(
					'{!themes:INPUT_TEMPLATE_NAME;^}',
					'example',
					function(file) {
						if (file!==null)
						{
							file=file.replace(/\..*$/,'');
							switch (subdir)
							{
								case 'templates':
									file+='.tpl';
									break;

								case 'css':
									file+='.css';
									break;

								case 'javascript':
									file+='.js';
									break;

								case 'text':
									file+='.txt';
									break;

								case 'xml':
									file+='.xml';
									break;
							}

							template_editor_add_tab(file);
						}
					},
					'{!themes:ADD_TEMPLATE;^}'
				);
			}
		},
		'{!themes:ADD_TEMPLATE;^}'
	);

	return false;
}

function template_editor_add_tab_wrap(file)
{
	template_editor_add_tab(document.getElementById('theme_files').value);
}

function template_editor_add_tab(file)
{
	var tab_title=file.replace(/^.*\//,'');

	var file_id=file_to_file_id(file);

	// Switch to tab if exists
	if (document.getElementById('t_'+file_id))
	{
		select_tab('g',file_id);

		template_editor_show_tab(file_id);

		return;
	}

	// Create new tab header
	var headers=document.getElementById('template_editor_tab_headers');
	var header=document.createElement('a');
	header.setAttribute('aria-controls','g_'+file_id);
	header.setAttribute('role','tab');
	header.setAttribute('href','#');
	header.id='t_'+file_id;
	header.className='tab file_nonchanged';
	header.onclick=function(event) {
		if (typeof event=='undefined') event=window.event;

		event.returnValue=false;

		select_tab('g',file_id);

		template_editor_show_tab(file_id);

		return false;
	};
	var span=document.createElement('span');
	span.innerText=tab_title;
	header.appendChild(span);
	var close_button=document.createElement('img');
	close_button.src='{$IMG;,icons/16x16/close}'.replace(/^https?:/,window.location.protocol);
	if (typeof close_button.srcset!='undefined')
		close_button.srcset='{$IMG;,icons/32x32/close} 2x'.replace(/^https?:/,window.location.protocol);
	close_button.alt='{!CLOSE;}';
	close_button.style.paddingLeft='5px';
	close_button.style.width='16px';
	close_button.style.height='16px';
	close_button.style.verticalAlign='middle';
	close_button.onclick=function(event) {
		if (typeof event=='undefined') event=window.event;
		cancel_bubbling(event);
		if (typeof event.preventDefault!='undefined') event.preventDefault();

		if (window.template_editor_open_files[file].unsaved_changes)
		{
			fauxmodal_confirm('{!themes:UNSAVED_CHANGES;^}'.replace('\{1\}',file),function(result) {
				if (result)
				{
					template_editor_tab_unload_content(file);
				}
			},'{!Q_SURE;}',true);
		} else {
			template_editor_tab_unload_content(file);
		}
	}
	header.appendChild(close_button);
	headers.appendChild(header);

	// Create new tab body
	var bodies=document.getElementById('template_editor_tab_bodies');
	var body=document.createElement('div');
	body.setAttribute('aria-labeledby','t_'+file_id);
	body.setAttribute('role','tabpanel');
	body.id='g_'+file_id;
	body.style.display='none';
	bodies.appendChild(body);

	// Set content
	var url=template_editor_loading_url(file);
	load_snippet(url,null,function(ajax_result) {
		template_editor_tab_loaded_content(ajax_result,file);
	});

	// Cleanup
	template_editor_clean_tabs();

	// Select tab
	select_tab('g',file_id);

	template_editor_show_tab(file_id);
}

function template_editor_loading_url(file,revision_id)
{
	var url='template_editor_load';
	url+='&file='+window.encodeURIComponent(file);
	url+='&theme='+window.encodeURIComponent(window.template_editor_theme);
	if (typeof window.template_editor_active_guid!='undefined')
	{
		url+='&active_guid='+window.encodeURIComponent(window.template_editor_active_guid);
	}
	if (typeof revision_id!='undefined')
	{
		url+='&undo_revision='+window.encodeURIComponent(revision_id);
	}
	return url;
}

function template_editor_show_tab(file_id)
{
	window.setTimeout(function() {
		if (document.getElementById('t_'+file_id).className.indexOf('tab_active')==-1)
		{
			// No longer visible
			return;
		}

		$('#e_'+file_id.replace(/\./g,'\\.')+'_wrap').resizable({
			resize: function(event,ui) {
				var editor=window.ace_editors['e_'+file_id];
				if (typeof editor!='undefined')
				{
					$('#e_'+file_id.replace(/\./g,'\\.')+'__ace')[0].style.height='100%';
					$('#e_'+file_id.replace(/\./g,'\\.')+'__ace')[0].parentNode.style.height='100%';
					editor.resize();
				}
			},
			handles: 's'
		});
	},1000);
}

function template_editor_tab_loaded_content(ajax_result,file)
{
	var file_id=file_to_file_id(file);

	set_inner_html(document.getElementById('g_'+file_id),ajax_result.responseText);

	window.setTimeout(function() {
		var textarea_id='e_'+file_id;
		if (editarea_is_loaded(textarea_id))
		{
			var editor=window.ace_editors[textarea_id];
			var editor_session=editor.getSession();
			editor_session.on('change',function() {
				template_editor_tab_mark_changed_content(file);
			});
		} else
		{
			add_event_listener_abstract(get_file_textbox(file),'change',function() {
				template_editor_tab_mark_changed_content(file);
			});
		}
	},100);

	window.template_editor_open_files[file]={
		unsaved_changes: false
	};
}

function template_editor_tab_mark_changed_content(file)
{
	window.template_editor_open_files[file].unsaved_changes=true;

	var file_id=file_to_file_id(file);
	var ob=document.getElementById('t_'+file_id);
	ob.className=ob.className.replace(/ file_nonchanged/,' file_changed');
}

function template_editor_tab_save_content(file)
{
	var url='template_editor_save';
	url+='&file='+window.encodeURIComponent(file);
	url+='&theme='+window.encodeURIComponent(window.template_editor_theme);
	editarea_reverse_refresh('e_'+file_to_file_id(file));
	var post='contents='+window.encodeURIComponent(get_file_textbox(file).value);
	load_snippet(url,post,function(ajax_result) {
		fauxmodal_alert(ajax_result.responseText,null,null,true);
		template_editor_tab_mark_nonchanged_content(file);
	});
}

function template_editor_tab_mark_nonchanged_content(file)
{
	window.template_editor_open_files[file].unsaved_changes=false;

	var file_id=file_to_file_id(file);
	var ob=document.getElementById('t_'+file_id);
	ob.className=ob.className.replace(/ file_changed/,' file_nonchanged');
}

function template_editor_get_tab_count()
{
	var count=0;
	for (var k in window.template_editor_open_files)
	{
		if (window.template_editor_open_files.hasOwnProperty(k)) count++;
	}
	return count;
}

function template_editor_tab_unload_content(file)
{
	var file_id=file_to_file_id(file);
	var was_active=template_editor_remove_tab(file_id);

	delete window.template_editor_open_files[file];

	if (was_active)
	{
		// Select tab
		var c=document.getElementById('template_editor_tab_headers').childNodes;
		if (typeof c[0]!='undefined')
		{
			var next_file_id=c[0].id.substr(2);

			select_tab('g',next_file_id);

			template_editor_show_tab(next_file_id);
		}
	}
}

function template_editor_remove_tab(file_id)
{
	var header=document.getElementById('t_'+file_id);
	if (header)
	{
		var is_active=(header.className.indexOf(' tab_active')!=-1);

		header.parentNode.removeChild(header);
		var body=document.getElementById('g_'+file_id);
		if (body) body.parentNode.removeChild(body);

		template_editor_clean_tabs();

		return is_active;
	}

	return false;
}

function template_editor_clean_tabs()
{
	var headers=document.getElementById('template_editor_tab_headers');
	var bodies=document.getElementById('template_editor_tab_bodies');
	var num_tabs=headers.childNodes.length;

	var header=document.getElementById('t_default');
	var body=document.getElementById('g_default');

	if (header && num_tabs>1)
	{
		header.parentNode.removeChild(header);
		body.parentNode.removeChild(body);
	}

	if (num_tabs==0)
	{
		set_inner_html(headers,'<a href="#" id="t_default" class="tab" onclick="event.returnValue=false;"><span>&mdash;</span></a>');
		set_inner_html(bodies,'<div id="g_default"><p class="nothing_here">{!NA}</p<</div>');
	}
}

function template_editor_restore_revision(file,revision_id)
{
	var file_id=file_to_file_id(file);

	// Set content from revision
	var url=template_editor_loading_url(file,revision_id);
	load_snippet(url,null,function(ajax_result) {
		document.getElementById('t_'+file_id).className='tab tab_active';

		template_editor_tab_loaded_content(ajax_result,file);
	});

	return false;
}

/* Editing */

function get_file_textbox(file)
{
	var ob=document.getElementById('e_'+file_to_file_id(file));
	return ob;
}

function template_editor_keypress(event)
{
	if (key_pressed(event,9))
	{
		insert_textbox(this,"\t");
		return false;
	}
	return true;
}

function insert_guid(file,guid)
{
	var textbox=get_file_textbox(file);

	var has_editarea=editarea_is_loaded(textbox.name);

	editarea_reverse_refresh('e_'+file_to_file_id(file));

	insert_textbox(textbox,'{'+'+START,IF,{'+'$EQ,{'+'_GUID},'+guid+'}}\n{'+'+END}');
	if (has_editarea) editarea_refresh(textbox.id);

	return false;
}

function template_insert_parameter(dropdown_name,file_id)
{
	var params='';

	var textbox=document.getElementById('e_'+file_id);

	editarea_reverse_refresh('e_'+file_id);

	var dropdown=document.getElementById(dropdown_name);
	var value=dropdown.options[dropdown.selectedIndex].value;
	var value_parts=value.split('__');
	value=value_parts[0];
	if (value=='---') return false;

	var has_editarea=editarea_is_loaded(textbox.name);

	if ((value=='BLOCK')/*{+START,IF,{$NOT,{$CONFIG_OPTION,js_overlays}}}*/ && (typeof window.showModalDialog!='undefined')/*{+END}*/)
	{
		var url='{$FIND_SCRIPT_NOHTTP;,block_helper}?field_name='+textbox.name+'&block_type=template'+keep_stub();
		window.faux_showModalDialog(
			maintain_theme_in_link(url),
			null,
			'dialogWidth=750;dialogHeight=600;status=no;resizable=yes;scrollbars=yes;unadorned=yes',
			function() {
				if (has_editarea) editarea_refresh(textbox.name);
			}
		);
		return;
	}

	var arity=value_parts[1];
	var definite_gets=0;
	if (arity=='1') definite_gets=1;
	else if (arity=='2') definite_gets=2;
	else if (arity=='3') definite_gets=3;
	else if (arity=='4') definite_gets=4;
	else if (arity=='5') definite_gets=5;
	else if (arity=='0-1') definite_gets=0;
	else if (arity=='3-4') definite_gets=3;
	else if (arity=='0+') definite_gets=0;
	else if (arity=='1+') definite_gets=1;
	var parameter=['A','B','C','D','E','F','G','H','I','J','K'];

	_get_parameter_parameters(
		definite_gets,
		parameter,
		arity,
		textbox,
		name,
		value,
		0,
		'',
		function(textbox,name,value,params) {
			if (name.indexOf('ppdirective')!=-1)
			{
				insert_textbox_wrapping(textbox,'{'+'+START,'+value+params+'}','{'+'+END}');
			} else
			{
				var st_value;
				if (name.indexOf('ppparameter')==-1)
				{
					st_value='{'+'$';
				} else
				{
					st_value='{';
				}

				value=st_value+value+'*'+params+'}';

				insert_textbox(textbox,value);
			}

			if (has_editarea) editarea_refresh(textbox.name);
		}
	);

	return false;
}

function _get_parameter_parameters(definite_gets,parameter,arity,box,name,value,num_done,params,callback)
{
	if (num_done<definite_gets)
	{
		window.fauxmodal_prompt(
			'{!themes:INPUT_NECESSARY_PARAMETER;^}'+', '+parameter[num_done],
			'',
			function(v) {
				if (v!==null)
				{
					params=params+','+v;
					_get_parameter_parameters(definite_gets,parameter,arity,box,name,value,num_done+1,params,callback);
				}
			},
			'{!themes:INSERT_PARAMETER;^}'
		);
	} else
	{
		if ((arity=='0+') || (arity=='1+'))
		{
			window.fauxmodal_prompt(
				'{!themes:INPUT_OPTIONAL_PARAMETER;^}',
				'',
				function(v) {
					if (v!==null)
					{
						params=params+','+v;
						_get_parameter_parameters(definite_gets,parameter,arity,box,name,value,num_done+1,params,callback);
					} else callback(box,name,value,params);
				},
				'{!themes:INSERT_PARAMETER;^}'
			);
		}
		else if ((arity=='0-1') || (arity=='3-4'))
		{
			window.fauxmodal_prompt(
				'{!themes:INPUT_OPTIONAL_PARAMETER;^}',
				'',
				function(v) {
					if (v!=null)
						params=params+','+v;
					callback(box,name,value,params);
				},
				'{!themes:INSERT_PARAMETER;^}'
			);
		}
		else callback(box,name,value,params);
	}
}

function css_equation_helper(file_id,theme)
{
	cancel_bubbling(event,this);

	var url='themewizard_equation';
	url+='&theme='+window.encodeURIComponent(theme);
	url+='&css_equation='+window.encodeURIComponent(document.getElementById('css_equation_'+file_id).value);

	var result=load_snippet(url);

	if (result=='' || result.indexOf('<html')!=-1)
		window.fauxmodal_alert('{!ERROR_OCCURRED;}');
	else
		document.getElementById('css_result_'+file_id).value=result;

	return false;
}

/* CSS */

function load_contextual_css_editor(file,file_id)
{
	window.doing_css_for=file.replace('.css','');

	var ui=document.getElementById('selectors_'+file_id);
	ui.style.display='block';
	var list=document.createElement('ul');
	document.getElementById('selectors_inner_'+file_id).appendChild(list);
	list.id='selector_list';

	set_up_parent_page_highlighting(file,file_id);

	// Set up background compiles
	if (typeof window.do_ajax_request!='undefined')
	{
		var textarea=get_file_textbox(file);
		editarea_reverse_refresh('e_'+file_id);
		var last_css=textarea.value;
		window.css_recompiler_timer=window.setInterval(function() {
			if ((window.opener) && (window.opener.document))
			{
				if (typeof window.opener.have_set_up_parent_page_highlighting=='undefined')
				{
					set_up_parent_page_highlighting(file,file_id);
					last_css='';/*force new CSS to apply*/
				}

				var new_value=textarea.value;
				if (new_value!=last_css)
				{
					var url='{$BASE_URL_NOHTTP;}/data/snippet.php?snippet=css_compile__text'+keep_stub();
					do_ajax_request(url,receive_compiled_css,'css='+window.encodeURIComponent(new_value));
				}
				last_css=new_value;
			}
		}, 2000 );
	}
}

function set_up_parent_page_highlighting(file,file_id)
{
	if (typeof window.opener.find_active_selectors=='undefined') return;
	window.opener.have_set_up_parent_page_highlighting=true;

	var li,a,selector,elements,element,j;
	var selectors=window.opener.find_active_selectors(window.doing_css_for,window.opener);
	var list=document.getElementById('selector_list_'+file_id),cssText;
	set_inner_html(list,'');

	for (var i=0;i<selectors.length;i++)
	{
		selector=selectors[i].selectorText;
		li=document.createElement('li');
		a=document.createElement('a');
		li.appendChild(a);
		a.href='#';
		a.id='selector_'+i;
		set_inner_html(a,escape_html(selector));
		list.appendChild(li);

		cssText=(typeof selectors[i].cssText=='undefined')?selectors[i].style.cssText:selectors[i].cssText;
		if (cssText.indexOf('{')!=-1)
		{
			cssText=cssText.replace(/ \{ /g,' {<br />\n&nbsp;&nbsp;&nbsp;').replace(/; \}/g,'<br />\n}').replace(/; /g,';<br />\n&nbsp;&nbsp;&nbsp;');
		} else // IE
		{
			cssText=cssText.toLowerCase().replace(/; /,';<br />\n');
		}
		li.onmouseout=function(event) { if (typeof event=='undefined') event=window.event; if (typeof window.deactivate_tooltip!='undefined') deactivate_tooltip(this); };
		li.onmousemove=function(event) { if (typeof event=='undefined') event=window.event; if (typeof window.activate_tooltip!='undefined') reposition_tooltip(this,event); };
		li.onmouseover=function(cssText) { return function(event) { if (typeof event=='undefined') event=window.event; if (typeof window.activate_tooltip!='undefined') activate_tooltip(this,event,cssText,'auto'); } } (cssText);

		// Jump-to
		a.onclick=function(selector) { return function(event) {
			cancel_bubbling(event);
			editarea_do_search(
				'e_'+file_id,
				'^[ \t]*'+selector.replace(/\./g,'\\.').replace(/\[/g,'\\[').replace(/\]/g,'\\]').replace(/\{/g,'\\{').replace(/\}/g,'\\}').replace(/\+/g,'\\+').replace(/\*/g,'\\*').replace(/\s/g,'[ \t]+')+'\\s*\\{'
			); // Opera does not support \s
			return false;
		} }(selector);

		// Highlighting on parent page
		a.onmouseover=function(selector) { return function(event) {
			if (typeof event=='undefined') event=window.event;

			if ((window.opener) && (!event.ctrlKey))
			{
				var elements=find_selectors_for(window.opener,selector);
				for (var i=0;i<elements.length;i++)
				{
					elements[i].style.outline='3px dotted green';
					elements[i].style.backgroundColor='green';
				}
			}
		} }(selector);
		a.onmouseout=function(selector) { return function(event) {
			if (typeof event=='undefined') event=window.event;

			if ((window.opener) && (!event.ctrlKey))
			{
				var elements=find_selectors_for(window.opener,selector);
				for (var i=0;i<elements.length;i++)
				{
					elements[i].style.outline='';
					elements[i].style.backgroundColor='';
				}
			}
		} }(selector);

		// Highlighting from parent page
		elements=find_selectors_for(window.opener,selector);
		for (j=0;j<elements.length;j++)
		{
			element=elements[j];

			add_event_listener_abstract(element,'mouseover',function(a,element) { return function(event) {
				if (typeof event=='undefined') event=window.event;

				if ((window) && (typeof window.dec_to_hex!='undefined') && (!event.ctrlKey))
				{
					var target=event.target || event.srcElement;
					var target_distance=0;
					var element_recurse=element;
					do
					{
						if (element_recurse==target) break;
						element_recurse=element_recurse.parentNode;
						target_distance++;
					}
					while (element_recurse);
					if (target_distance>10) target_distance=10; // Max range

					a.style.outline='1px dotted green';
					a.style.background='#00'+(dec_to_hex(255-target_distance*25))+'00';
					if (target_distance>4)
						a.style.color='white';
					else
						a.style.color='black';
				}
			} }(a,element) );
			add_event_listener_abstract(element,'mouseout',function(a) { return function(event) {
				if (typeof event=='undefined') event=window.event;

				if ((window) && (!event.ctrlKey))
				{
					a.style.outline='';
					a.style.background='';
					a.style.color='';
				}
			} }(a) );
		}
	}
}

function dec_to_hex(number)
{
	var hexbase='0123456789ABCDEF';
	return hexbase.charAt((number>>4)&0xf)+hexbase.charAt(number&0xf);
}

function find_selectors_for(opener,selector)
{
	var result=[],result2;
	try
	{
		result2=opener.document.querySelectorAll(selector);
		for (var j=0;j<result2.length;j++) result.push(result2[j]);
	}
	catch (e) {}
	for (var i=0;i<opener.frames.length;i++)
	{
		if (opener.frames[i]) // If test needed for some browsers, as window.frames can get out-of-date
		{
			result2=find_selectors_for(opener.frames[i],selector);
			for (var j=0;j<result2.length;j++) result.push(result2[j]);
		}
	}
	return result;
}

function receive_compiled_css(ajax_result_frame,win)
{
	if ((typeof win=='undefined') || (!win)) var win=window.opener;

	if (win)
	{
		try
		{
			var css=ajax_result_frame.responseText;

			// Remove old link tag
			var e;
			if (window.doing_css_for=='no_cache')
			{
				e=win.document.getElementById('inline_css');
				if (e)
				{
					e.parentNode.removeChild(e);
				}
			} else
			{
				var links=win.document.getElementsByTagName('link');
				for (var i=0;i<links.length;i++)
				{
					e=links[i];
					if ((e.type=='text/css') && (e.href.indexOf('/templates_cached/'+window.opener.cms_lang+'/'+window.doing_css_for)!=-1))
					{
						e.parentNode.removeChild(e);
					}
				}
			}

			// Create style tag for this
			var style=win.document.getElementById('style_for_'+window.doing_css_for);
			if (!style) style=win.document.createElement('style');
			style.type='text/css';
			style.id='style_for_'+window.doing_css_for;
			if (style.styleSheet)
			{
				style.styleSheet.cssText=css;
			} else
			{
				if (typeof style.childNodes[0]!='undefined') style.removeChild(style.childNodes[0]);
				var tn=win.document.createTextNode(css);
				style.appendChild(tn);
			}
			win.document.getElementsByTagName('head')[0].appendChild(style);

			for (var i=0;i<win.frames.length;i++)
			{
				if (win.frames[i]) // If test needed for some browsers, as window.frames can get out-of-date
				{
					receive_compiled_css(ajax_result_frame,win.frames[i]);
				}
			}
		}
		catch (ex) {}
	}
}

