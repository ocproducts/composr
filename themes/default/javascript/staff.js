"use strict";

function script_load_stuff_staff() {
    // Navigation loading screen
    if (Composr.is(Composr.$CONFIG_OPTION.enableAnimations)) {
        if ((window.parent === window) && ((window.location + '').indexOf('js_cache=1') == -1) && (((window.location + '').indexOf('/cms/') != -1) || ((window.location + '').indexOf('/adminzone/') != -1))) {
            window.addEventListener('beforeunload', function () {
                staff_unload_action();
            });
        }
    }

    // Theme image editing hovers
    var i, j;
    for (i = 0; i < document.images.length; i++) {
        if (document.images[i].className.indexOf('no_theme_img_click') == -1) {
            document.images[i].addEventListener('mouseover', handle_image_mouse_over);
            document.images[i].addEventListener('mouseout', handle_image_mouse_out);
            document.images[i].addEventListener('click', handle_image_click);
        }
    }
    var inputs = document.getElementsByTagName('input');
    for (i = 0; i < inputs.length; i++) {
        if ((inputs[i].className.indexOf('no_theme_img_click') == -1) && (inputs[i].type == 'image')) {
            inputs[i].addEventListener('mouseover', handle_image_mouse_over);
            inputs[i].addEventListener('mouseout', handle_image_mouse_out);
            inputs[i].addEventListener('click', handle_image_click);
        }
    }

    var all_e = document.getElementsByTagName('*');
    var bg;
    for (i = 0; i < all_e.length; i++) {
        bg = window.getComputedStyle(all_e[i]).getPropertyValue('background-image');
        if ((all_e[i].className.indexOf('no_theme_img_click') == -1) && (bg != 'none') && (bg.indexOf('url') != -1)) {
            all_e[i].addEventListener('mouseover', handle_image_mouse_over);
            all_e[i].addEventListener('mouseout', handle_image_mouse_out);
            all_e[i].addEventListener('click', handle_image_click);
        }
    }

	// Thumbnail tooltips
	var url_patterns=[
		/*{+START,LOOP,URL_PATTERNS}*/
			/*{+START,IF,{$NEQ,{_loop_key},0}},{+END}*/
			{
				pattern: /^{$REPLACE,_WILD,([^&]*),{$REPLACE,_WILD\/,([^&]*)\/?,{$REPLACE,?,\?,{$REPLACE,/,\/,{PATTERN}}}}}/,
				hook: '{HOOK}'
			}
		/*{+END}*/
	];
	var cells=document.getElementsByTagName('td');
	var links=[];
	if (window.location.href.replace('{$BASE_URL_NOHTTP;}','').indexOf('/cms/')!=-1/*{+START,IF,{$DEV_MODE}}*/ || true/*{+END}*/)
	{
		for (var i=0;i<cells.length;i++)
		{
			var as=cells[i].getElementsByTagName('a');
			for (var j=0;j<as.length;j++)
			{
				links.push(as[j]);
			}
		}
	}
	for (var i=0;i<links.length;i++)
	{
		for (var j=0;j<url_patterns.length;j++)
		{
			var url_pattern=url_patterns[j].pattern,hook=url_patterns[j].hook;

			if ((links[i].href) && (!links[i].onmouseover))
			{
				var id=links[i].href.match(url_pattern);
				if (id)
				{
					apply_comcode_tooltip(hook,id,links[i]);
				}
			}
		}
	}
}

/*
TOOLTIPS FOR THUMBNAILS TO CONTENT, AS DISPLAYED IN CMS ZONE
*/

function apply_comcode_tooltip(hook,id,link)
{
	link.addEventListener('mouseout',function(event) {
		if (typeof window.deactivate_tooltip!='undefined') deactivate_tooltip(link);
	});
	link.addEventListener('mousemove',function(event) {
		if (typeof window.activate_tooltip!='undefined') reposition_tooltip(link,event,false,false,null,true);
	});
	link.addEventListener('mouseover',function(event) {
		if (typeof window.activate_tooltip!='undefined')
		{
			var id_chopped=id[1];
			if (typeof id[2]!='undefined') id_chopped+=':'+id[2];
			var comcode='[block="'+hook+'" id="'+window.decodeURIComponent(id_chopped)+'" no_links="1"]main_content[/block]';
			if (typeof link.rendered_tooltip=='undefined')
			{
				link.is_over=true;

				var request=do_ajax_request(maintain_theme_in_link('{$FIND_SCRIPT_NOHTTP;,comcode_convert}?css=1&javascript=1&raw_output=1&box_title={!PREVIEW&;^}'+keep_stub(false)),function(ajax_result_frame) {
					if (ajax_result_frame && ajax_result_frame.responseText)
					{
						link.rendered_tooltip=ajax_result_frame.responseText;
					}
					if (typeof link.rendered_tooltip!='undefined')
					{
						if (link.is_over)
							activate_tooltip(link,event,link.rendered_tooltip,'400px',null,null,false,false,false,true);
					}
				},'data='+window.encodeURIComponent(comcode));
			} else
			{
				activate_tooltip(link,event,link.rendered_tooltip,'400px',null,null,false,false,false,true);
			}
		}
	});
}

/*
STAFF ACTIONS LINKS
*/

function staff_actions_select(ob)
{
	var form;

	var is_form_submit=(ob.localName==='form'); // If it already is a form submission, i.e. we don't need to trigger a form.submit() ourselves
	if (is_form_submit)
	{
		form=ob;
		ob=form.elements['special_page_type'];
	} else
	{
		form=ob.form;
	}

	var val=ob.options[ob.selectedIndex].value;
	if (val!='view')
	{
		if (typeof form.elements['cache']!='undefined')
			form.elements['cache'].value=(val.substring(val.length-4,val.length)=='.css')?'1':'0';
		var window_name='cms_dev_tools'+Math.floor(Math.random()*10000);
		var window_options;
		if (val=='templates')
		{
			window_options='width='+window.screen.availWidth+',height='+window.screen.availHeight+',scrollbars=yes';

			window.setTimeout(function() { // Do a refresh with magic markers, in a comfortable few seconds
				var old_url=window.location.href;
				if (old_url.indexOf('keep_template_magic_markers=1')==-1)
				{
					window.location.href=old_url+((old_url.indexOf('?')==-1)?'?':'&')+'keep_template_magic_markers=1&cache_blocks=0&cache_comcode_pages=0';
				}
			},10000);
		} else
		{
			window_options='width=1020,height=700,scrollbars=yes';
		}
		var test=window.open('',window_name,window_options);
		if (test) form.setAttribute('target',test.name);
		if (!is_form_submit)
			form.submit();
	}
}

/*
THEME IMAGE CLICKING
*/

function handle_image_mouse_over(event)
{
	var target=event.target;
	if (target.previousSibling && (typeof target.previousSibling.className!='undefined') && (typeof target.previousSibling.className.indexOf!='undefined') && (target.previousSibling.className.indexOf('magic_image_edit_link')!=-1)) return;
	if (target.offsetWidth<130) return;

	var src=(typeof target.src=='undefined')?window.getComputedStyle(target).getPropertyValue('background-image'):target.src;
	if ((typeof target.src=='undefined') && (!event.ctrlKey) && (!event.metaKey) && (!event.altKey)) return; // Needs ctrl key for background images
	if (src.indexOf('/themes/')==-1) return;
	if (window.location.href.indexOf('admin_themes')!=-1) return;

	/*{+START,IF,{$CONFIG_OPTION,enable_theme_img_buttons}}*/
		// Remove other edit links
		var old=document.querySelectorAll('.magic_image_edit_link');
		for (var i=old.length-1;i>=0;i--)
		{
			old[i].parentNode.removeChild(old[i]);
		}

		// Add edit button
		var ml=document.createElement('input');
		ml.onclick=function(event) { handle_image_click(event,target,true); };
		ml.type='button';
		ml.id='editimg_'+target.id;
		ml.value='{!themes:EDIT_THEME_IMAGE;^}';
		ml.className='magic_image_edit_link button_micro';
		ml.style.position='absolute';
		ml.style.left=find_pos_x(target)+'px';
		ml.style.top=find_pos_y(target)+'px';
		ml.style.zIndex=3000;
		ml.style.display='none';
		target.parentNode.insertBefore(ml,target);

		if (target.mo_link)
			window.clearTimeout(target.mo_link);
		target.mo_link=window.setTimeout(function() {
			if (ml) ml.style.display='block';
		} , 2000);
	/*{+END}*/

	window.old_status_img=window.status;
	window.status='{!SPECIAL_CLICK_TO_EDIT;^}';
}

function handle_image_mouse_out(event)
{
	var target=event.target;

	/*{+START,IF,{$CONFIG_OPTION,enable_theme_img_buttons}}*/
		if (target.previousSibling && (typeof target.previousSibling.className!='undefined') && (typeof target.previousSibling.className.indexOf!='undefined') && (target.previousSibling.className.indexOf('magic_image_edit_link')!=-1))
		{
			if ((typeof target.mo_link!='undefined') && (target.mo_link)) // Clear timed display of new edit button
			{
				window.clearTimeout(target.mo_link);
				target.mo_link=null;
			}

			// Time removal of edit button
			if (target.mo_link)
				window.clearTimeout(target.mo_link);
			target.mo_link=window.setTimeout(function() {
				if ((typeof target.edit_window=='undefined') || (!target.edit_window) || (target.edit_window.closed))
				{
					if (target.previousSibling && (typeof target.previousSibling.className!='undefined') && (typeof target.previousSibling.className.indexOf!='undefined') && (target.previousSibling.className.indexOf('magic_image_edit_link')!=-1))
						target.parentNode.removeChild(target.previousSibling);
				}
			} , 3000);
		}
	/*{+END}*/

	if (typeof window.old_status_img=='undefined') window.old_status_img='';
	window.status=window.old_status_img;
}

function handle_image_click(event,ob,force)
{
	if ((typeof ob=='undefined') || (!ob)) var ob=this;

	var src=ob.origsrc?ob.origsrc:((typeof ob.src=='undefined')?window.getComputedStyle(ob).getPropertyValue('background-image').replace(/.*url\(['"]?(.*)['"]?\).*/,'$1'):ob.src);
	if ((src) && ((force) || (magic_keypress(event))))
	{
		// Bubbling needs to be stopped because shift+click will open a new window on some lower event handler (in firefox anyway)
		cancel_bubbling(event);

		if (typeof event.preventDefault!='undefined') event.preventDefault();

		if (src.indexOf('{$BASE_URL_NOHTTP;}/themes/')!=-1)
			ob.edit_window=window.open('{$BASE_URL;,0}/adminzone/index.php?page=admin_themes&type=edit_image&lang='+window.encodeURIComponent(Composr.$LANG)+'&theme='+window.encodeURIComponent(Composr.$THEME)+'&url='+window.encodeURIComponent(src.replace('{$BASE_URL;,0}/',''))+keep_stub(),'edit_theme_image_'+ob.id);
		else window.fauxmodal_alert('{!NOT_THEME_IMAGE;^}');

		return false;
	}

	return true;
}

/*
SOFTWARE CHAT
*/

function load_software_chat(event)
{
	cancel_bubbling(event);
	if (typeof event.preventDefault!='undefined') event.preventDefault();

	var url='https://kiwiirc.com/client/irc.kiwiirc.com/?nick=';
	if (Composr.$USERNAME != 'admin') {
		url+=window.encodeURIComponent(Composr.$USERNAME.replace(/[^a-zA-Z0-9\_\-\\\[\]\{\}\^`|]/g,''));
	} else {
		url+=window.encodeURIComponent(Composr.$SITE_NAME.replace(/[^a-zA-Z0-9\_\-\\\[\]\{\}\^`|]/g,''));
	}
	url+='#composrcms';
	var html=' \
		<div class="software_chat"> \
			<h2>{!CMS_COMMUNITY_HELP;^}</h2> \
			<ul class="spaced_list">{!SOFTWARE_CHAT_EXTRA;^}</ul> \
			<p class="associated_link associated_links_block_group"><a title="{!SOFTWARE_CHAT_STANDALONE;^} {!LINK_NEW_WINDOW;^}" target="_blank" href="'+escape_html(url)+'">{!SOFTWARE_CHAT_STANDALONE;^}</a> <a href="#!" onclick="return load_software_chat(event);">{!HIDE;^}</a></p> \
		</div> \
		<iframe class="software_chat_iframe" style="border: 0" src="'+escape_html(url)+'"></iframe> \
	'.replace(/\\{1\\}/,escape_html((window.location+'').replace(get_base_url(),'http://baseurl')));

	var box=document.getElementById('software_chat_box');
	if (box)
	{
		box.parentNode.removeChild(box);

		set_opacity(document.getElementById('software_chat_img'),1.0);
	} else
	{
		box=document.createElement('div');

		var width=950;
		var height=550;
		box.id='software_chat_box';
		box.style.width=width+'px';
		box.style.height=height+'px';
		box.style.background='#EEE';
		box.style.color='#000';
		box.style.padding='5px';
		box.style.border='3px solid #AAA';
		box.style.position='absolute';
		box.style.zIndex=2000;
		box.style.left=(get_window_width()-width)/2+'px';
		var top_temp=100;
		box.style.top=top_temp+'px';

		Composr.dom.html(box, html);
		document.body.appendChild(box);

		smooth_scroll(0);

		set_opacity(document.getElementById('software_chat_img'),0.5);
	}

	return false;
}

/*
ADMIN ZONE DASHBOARD
*/

function set_task_hiding(hide_done)
{
	new Image().src='{$IMG;,checklist/cross2}';
	new Image().src='{$IMG;,checklist/toggleicon2}';

	var checklist_rows=document.querySelectorAll('.checklist_row'),row_imgs,src;
	for (var i=0;i<checklist_rows.length;i++)
	{
		row_imgs=checklist_rows[i].getElementsByTagName('img');
		if (hide_done)
		{
			src=row_imgs[row_imgs.length-1].getAttribute('src');
			if (row_imgs[row_imgs.length-1].origsrc) src=row_imgs[row_imgs.length-1].origsrc;
			if (src && src.indexOf('checklist1')!=-1)
			{
				checklist_rows[i].style.display='none';
				checklist_rows[i].className+=' task_hidden';
			} else
			{
				checklist_rows[i].className=checklist_rows[i].className.replace(/ task_hidden/g,'');
			}
		} else
		{
			if ((checklist_rows[i].style.display=='none')) {
				set_opacity(checklist_rows[i],0.0);
				fade_transition(checklist_rows[i],100,30,4);
			}
			checklist_rows[i].style.display='block';
			checklist_rows[i].className=checklist_rows[i].className.replace(/ task_hidden/g,'');
		}
	}

	if (hide_done)
	{
		document.getElementById('checklist_show_all_link').style.display='block';
		document.getElementById('checklist_hide_done_link').style.display='none';
	} else
	{
		document.getElementById('checklist_show_all_link').style.display='none';
		document.getElementById('checklist_hide_done_link').style.display='block';
	}
}

function submit_custom_task(form)
{
	var new_task=load_snippet('checklist_task_manage','type=add&recur_every='+window.encodeURIComponent(form.elements['recur_every'].value)+'&recur_interval='+window.encodeURIComponent(form.elements['recur_interval'].value)+'&task_title='+window.encodeURIComponent(form.elements['new_task'].value));

	form.elements['recur_every'].value='';
	form.elements['recur_interval'].value='';
	form.elements['new_task'].value='';

	Composr.dom.appendHtml(document.getElementById('custom_tasks_go_here'),new_task);

	return false;
}

function delete_custom_task(ob,id)
{
	load_snippet('checklist_task_manage','type=delete&id='+window.encodeURIComponent(id));
	ob.parentNode.parentNode.parentNode.style.display='none';

	return false;
}

function mark_done(ob,id)
{
	load_snippet('checklist_task_manage','type=mark_done&id='+window.encodeURIComponent(id));
	ob.onclick=function() { mark_undone(ob,id); };
	ob.getElementsByTagName('img')[1].setAttribute('src','{$IMG;,checklist/checklist1}');
}

function mark_undone(ob,id)
{
	load_snippet('checklist_task_manage','type=mark_undone&id='+window.encodeURIComponent(id));
	ob.onclick=function() { mark_done(ob,id); };
	ob.getElementsByTagName('img')[1].setAttribute('src','{$IMG;,checklist/not_completed}');
}

function staff_block_flip_over(name)
{
	var show=document.getElementById(name+'_form');
	var hide=document.getElementById(name);

	set_display_with_aria(show,(hide.style.display!='none')?'block':'none');
	set_display_with_aria(hide,(hide.style.display!='none')?'none':'block');

	return false;
}
