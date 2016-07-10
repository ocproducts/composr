"use strict";

function update_details_box(element)
{
	if (typeof window.sitemap=='undefined') return;
	if (typeof window.actions_tpl_item=='undefined') return;
	if (typeof window.info_tpl_item=='undefined') return;
	if (typeof window.actions_tpl=='undefined') return;
	if (typeof window.info_tpl=='undefined') return;

	var target=document.getElementById('details_target');
	if (element.value=='')
	{
		set_inner_html(target,'{!zones:NO_ENTRY_POINT_SELECTED;^}');
		return;
	}

	var node=window.sitemap.getElementByIdHack(element.value);
	var type=node.getAttribute('type');
	var page_link=node.getAttribute('serverid');
	var page_link_bits=page_link.split(/:/);
	var full_type=type;
	if (full_type.indexOf('/')!=-1) full_type=full_type.substr(0,full_type.indexOf('/'));

	var action_buildup='';
	var info_buildup='';
	var path;
	switch (full_type)
	{
		case 'root':
			action_buildup+=window.actions_tpl_item.replace(/\[1\]/,'{!zones:ADD_ZONE;^}').replace(/\[2\]/,window.add_zone_url);
			break;

		case 'zone':
			action_buildup+=window.actions_tpl_item.replace(/\[1\]/,'{!zones:ZONE_EDITOR;^}').replace(/\[2\]/,window.zone_editor_url.replace(/%21/,page_link.replace(/:/,'',page_link)));
			action_buildup+=window.actions_tpl_item.replace(/\[1\]/,'{!permissions:PERMISSIONS_TREE;^}').replace(/\[2\]/,window.permission_tree_editor_url.replace(/%21/,page_link.replace(/:/,'%3A',page_link)));
			action_buildup+=window.actions_tpl_item.replace(/\[1\]/,'{!zones:EDIT_ZONE;^}').replace(/\[2\]/,window.edit_zone_url.replace(/%21/,page_link.replace(/:/,'',page_link)));
			action_buildup+=window.actions_tpl_item.replace(/\[1\]/,'{!zones:COMCODE_PAGE_ADD;^}').replace(/\[2\]/,window.add_page_url.replace(/%21/,page_link.replace(/:/,'',page_link)));
			break;

		case 'modules':
		case 'modules_custom':
		case 'minimodule':
		case 'minimodule_custom':
			path=page_link_bits[0]+((page_link_bits[0]=='')?'':'/')+'pages/'+type+'/'+page_link_bits[1]+'.php';
			/*{+START,IF,{$ADDON_INSTALLED,code_editor}}{+START,IF,{$NOT,{$CONFIG_OPTION,collapse_user_zones}}}*/
			action_buildup+=window.actions_tpl_item.replace(/\[1\]/,'{!EDIT;^}').replace(/\[2\]/,'{$BASE_URL;,0}/code_editor.php?path='+window.encodeURIComponent(path));
			/*{+END}{+END}*/
			switch (type)
			{
				case 'modules':
				case 'modules_custom':
					action_buildup+=window.actions_tpl_item.replace(/\[1\]/,'{!permissions:PERMISSIONS_TREE;^}').replace(/\[2\]/,window.permission_tree_editor_url.replace(/%21/,page_link.replace(/:/,'%3A',page_link)));
					if (node.getAttribute('author')) info_buildup+=window.info_tpl_item.replace(/\[1\]/,'{!AUTHOR;^}').replace(/\[2\]/,escape_html(node.getAttribute('author')));
					if (node.getAttribute('organisation')) info_buildup+=window.info_tpl_item.replace(/\[1\]/,'{!ORGANISATION;^}').replace(/\[2\]/,escape_html(node.getAttribute('organisation')));
					if (node.getAttribute('version')) info_buildup+=window.info_tpl_item.replace(/\[1\]/,'{!VERSION;^}').replace(/\[2\]/,escape_html(node.getAttribute('version')));
					break;
				case 'minimodule':
				case 'minimodule_custom':
					break;
			}
			break;

		case 'comcode':
		case 'comcode_custom':
			path=page_link_bits[0]+'/pages/'+full_type+'/'+page_link_bits[1]+'.txt';
			action_buildup+=window.actions_tpl_item.replace(/\[1\]/,'{!permissions:PERMISSIONS_TREE;^}').replace(/\[2\]/,window.permission_tree_editor_url.replace(/%21/,page_link.replace(/:/,'%3A',page_link)));
			action_buildup+=window.actions_tpl_item.replace(/\[1\]/,'{!EDIT;^}').replace(/\[2\]/,window.edit_page_url.replace(/%21/,page_link));
			break;

		case 'html':
		case 'html_custom':
			path=page_link_bits[0]+'/pages/'+full_type+'/'+page_link_bits[1]+'.htm';
			break;

		case 'entry_point':
			break;
	}

	// Pages
	if (['modules','modules_custom','comcode','comcode_custom','html','html_custom'].indexOf(full_type)!=-1)
	{
		action_buildup+=window.actions_tpl_item.replace(/\[1\]/,'{!DELETE;^}').replace(/\[2\]/,window.delete_url.replace(/%5B1%5D/,page_link_bits[0]).replace(/\[2\]/,page_link_bits[1]));
		/*{+START,IF,{$ADDON_INSTALLED,stats}}*/
			if (window.stats_url!='') action_buildup+=window.actions_tpl_item.replace(/\[1\]/,'{!stats:PAGES_STATISTICS;^}').replace(/\[2\]/,window.stats_url.replace(/%21/,path));
		/*{+END}*/
	}

	// All
	if (full_type!='root')
	{
		action_buildup+=window.actions_tpl_item.replace(/\[1\]/,'{!VIEW;^}').replace(/\[2\]/,escape_html(('{$BASE_URL;,0}/data/page_link_redirect.php?id='+window.encodeURIComponent(page_link)+keep_stub())));
		info_buildup+=window.info_tpl_item.replace(/\[1\]/,'{!PAGE_LINK;^}').replace(/\[2\]/,'<kbd>'+escape_html(page_link)+'</kbd>');
		if (element.selected_editlink)
			action_buildup+=window.actions_tpl_item.replace(/\[1\]/,'{!EDIT;^}').replace(/\[2\]/,escape_html('{$FIND_SCRIPT_NOHTTP;,page_link_redirect}?id='+element.selected_editlink+keep_stub()));
	}

	// Output
	set_inner_html(target,'');
	if (action_buildup!='')
	{
		var actions=document.createElement('div');
		set_inner_html(actions,window.actions_tpl.replace(/\[1\]/,action_buildup));
		target.appendChild(actions);
	}
	if (info_buildup!='')
	{
		var info=document.createElement('div');
		set_inner_html(info,window.info_tpl.replace(/\[1\]/,info_buildup));
		target.appendChild(info);
	}
}

function drag_page(from,to)
{
	var new_zone=to.replace(/:/,'');
	var bits=from.split(/:/);
	if (bits.length==1) // Workaround IE bug
	{
		bits.push(bits[0]);
		bits[0]='';
	}

	var my_url=window.move_url.replace(/%5B1%5D/,bits[0]).replace(/\[2\]/,bits[1]).replace(/%5B3%5D/,new_zone);

	window.open(my_url,'move_page');
}


